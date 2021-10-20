// Forked from https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.mm

#import <objc/runtime.h>
#import <stdio.h>
#import <stdlib.h>
#import "HostObjectObjc.h"
#import "HostObjectClass.h"
#import "HostObjectClassInstance.h"
#import "HostObjectSelector.h"
#import "HostObjectProtocol.h"
#import "JSIUtils.h"
#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>
#import <React/RCTBridge+Private.h>
#import <ReactCommon/RCTTurboModule.h>
#import <ReactCommon/CallInvoker.h>
#import <React/RCTBridge.h>
#import <ReactCommon/TurboModuleUtils.h>
#import <jsi/jsi.h>
#import <dlfcn.h>

std::vector<jsi::PropNameID> HostObjectObjc::getPropertyNames(jsi::Runtime& rt) {
  std::vector<jsi::PropNameID> result;
  result.push_back(jsi::PropNameID::forUtf8(rt, std::string("toString")));
  
  // List out the classes
  int numClasses = objc_getClassList(NULL, 0);
  Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) *numClasses);
  numClasses = objc_getClassList(classes, numClasses);
  for (int i = 0; i < numClasses; i++) {
    result.push_back(jsi::PropNameID::forUtf8(rt, std::string(class_getName(classes[i]))));
  }
  free(classes);
  
  // I'm not aware of any objc runtime function by which to list out selectors and protocols!
  return result;
}

jsi::Value HostObjectObjc::get(jsi::Runtime& runtime, const jsi::PropNameID& propName) {
  auto name = propName.utf8(runtime);
  NSString* nameNSString = [NSString stringWithUTF8String:name.c_str()];

  if (name == "toString") {
    auto toString = [this] (jsi::Runtime& runtime, const jsi::Value&, const jsi::Value*, size_t) -> jsi::Value {
      NSString* string = [NSString stringWithFormat:@"[object HostObjectObjc]"];
      return jsi::String::createFromUtf8(runtime, string.UTF8String);
    };
    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "toString"), 0, toString);
  }
  
  // TODO: replace with toJS() class instance method
  if (name == "marshal") {
    auto marshal = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
      if(!arguments[0].isObject()){
        throw jsi::JSError(runtime, "TypeError: expected to be passed a HostObjectClassInstance.");
      }
      jsi::Object obj = arguments[0].asObject(runtime);
      if(!obj.isHostObject((runtime))){
        throw jsi::JSError(runtime, "TypeError: expected to be passed a HostObjectClassInstance.");
      }
      if(HostObjectClassInstance* hostObjectClassInstance = dynamic_cast<HostObjectClassInstance*>(obj.asHostObject(runtime).get())){
        return convertObjCObjectToJSIValue(runtime, hostObjectClassInstance->instance_);
      }
      
      throw jsi::JSError(runtime, "TypeError: expected to be passed a HostObjectClassInstance.");
    };
    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "marshal"), 1, marshal);
  }
  
  if (name == "getSelector") {
    auto getSelector = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
      if(!arguments[0].isString()){
        throw jsi::JSError(runtime, "TypeError: expected to be passed a String.");
      }
      RCTBridge *bridge = [RCTBridge currentBridge];
      auto jsCallInvoker = bridge.jsCallInvoker;
      NSString *selectorName = convertJSIValueToObjCObject(runtime, arguments[0], jsCallInvoker);

      SEL sel = NSSelectorFromString(selectorName);
      if(!sel){
        return jsi::Value::undefined();
      }
      
      jsi::Object object = jsi::Object::createFromHostObject(runtime, std::make_unique<HostObjectSelector>(sel));
      return object;
    };
    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "getSelector"), 1, getSelector);
  }
  
  // Cover all the type lookup utilities one-by-one!
  // @see https://developer.apple.com/documentation/foundation/object_runtime/objective-c_runtime_utilities?language=objc

  Class clazz = NSClassFromString(nameNSString);
  if (clazz != nil) {
    // TODO: read up on std::make_shared, std::make_unique, etc. and choose the best one
    jsi::Object object = jsi::Object::createFromHostObject(runtime, std::make_unique<HostObjectClass>(clazz));
    return object;
  }
  
  Protocol *protocol = NSProtocolFromString(nameNSString);
  if (protocol != nil) {
    jsi::Object object = jsi::Object::createFromHostObject(runtime, std::make_unique<HostObjectProtocol>(protocol));
    return object;
  }
  
  // We don't attempt implicit selector lookup because surprisingly the string @"NSStringTransformLatinToHiragana"
  // yields a selector (when we'd expect it to yield a variable instead; it's a global variable).
  
  void *value = dlsym(RTLD_MAIN_ONLY, [nameNSString cStringUsingEncoding:NSUTF8StringEncoding]);
  if (!value) {
    value = dlsym(RTLD_SELF, [nameNSString cStringUsingEncoding:NSUTF8StringEncoding]);
  }
  if (!value) {
    value = dlsym(RTLD_DEFAULT, [nameNSString cStringUsingEncoding:NSUTF8StringEncoding]);
  }
  if(!value) {
    throw jsi::JSError(runtime, [[NSString stringWithFormat:@"ReferenceError: Can't find symbol within this executable: %@", nameNSString] cStringUsingEncoding:NSUTF8StringEncoding]);
  }
  
  // dlsym() returns a pointer to the given data.
  // e.g. if we looked up `NSString* NSStringTransformToLatin`, it would return us not the NSString* directly, but a pointer to that NSString*.
  // Thus, we need to dereference it using this piece of witchcraft below.
  // @see https://stackoverflow.com/questions/23742392/how-do-i-cast-void-to-nsstring-without-getting-a-runtime-error-in-objective-c
  id valueObjc = *((__unsafe_unretained id*)value);
  
  // isKindOfClass checks whether valueObjc is an instance of any subclass of NSObject or NSObject itself.
  if(![valueObjc isKindOfClass:[NSObject class]]){
    throw jsi::JSError(runtime, [[NSString stringWithFormat:@"TypeError: Did find the symbol named '%@', but it's not a type we can currently handle (expected a class instance).", nameNSString] cStringUsingEncoding:NSUTF8StringEncoding]);
  }
  
  return jsi::Object::createFromHostObject(runtime, std::make_shared<HostObjectClassInstance>(valueObjc));
}
