// Forked from https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.mm

#import <objc/runtime.h>
#import <stdio.h>
#import <stdlib.h>
#import "HostObjectObjc.h"
#import "HostObjectClass.h"
#import "HostObjectClassInstance.h"
#import "HostObjectSelector.h"
#import "HostObjectProtocol.h"
#import "gObjcConstants.h"
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
  result.push_back(jsi::PropNameID::forUtf8(rt, std::string("marshal")));
  
  // List out the classes
  int numClasses = objc_getClassList(NULL, 0);
  Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) *numClasses);
  numClasses = objc_getClassList(classes, numClasses);
  for (int i = 0; i < numClasses; i++) {
    result.push_back(jsi::PropNameID::forUtf8(rt, std::string(class_getName(classes[i]))));
  }
  free(classes);
  
  for (NSString* key in [gObjcConstants allKeys] ) {
    result.push_back(jsi::PropNameID::forUtf8(rt, std::string([key UTF8String], [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding])));
  }
  
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
  
  if (name == "lookup") {
    auto lookup = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
      if(!arguments[0].isString()){
        throw jsi::JSError(runtime, "TypeError: expected to be passed a string.");
      }
      
      RCTBridge *bridge = [RCTBridge currentBridge];
      auto jsCallInvoker = bridge.jsCallInvoker;
      NSString *symbolName = convertJSIValueToObjCObject(runtime, arguments[0], jsCallInvoker);
      
      // @see https://stackoverflow.com/questions/6530701/is-the-function-dlopen-private-api
      // @see https://gist.github.com/alloy/9277316
      // @see https://stackoverflow.com/questions/10830488/where-are-the-ios-frameworks-binaries-located-in-the-filesystem
      
      // Here's how Xamarin looks up symbols specifically within a given framework.
      // We might want to offer explicitly scoped lookup like this as an option in future.
      // @see https://github.com/xamarin/xamarin-macios/blob/2972e1b715a11dd508023ea5bb71085d4dbf43ce/src/ObjCRuntime/Constants.cs#L6
      // @see https://github.com/xamarin/xamarin-macios/blob/80c3cc0028bc61cf6efc51b6972fa472519be100/src/Constants.iOS.cs.in
      // void *foundationLibraryHandle = dlopen([@"/System/Library/Frameworks/Foundation.framework/Foundation" fileSystemRepresentation], RTLD_LAZY);
      // void *allLibrariesHandle = dlopen(NULL, RTLD_LAZY);
      // char *error = dlerror();
      // if(error){
      //   NSString *errorString = [[NSString alloc] initWithUTF8String:error];
      //   NSLog(@"Got dlopen error: %@", errorString);
      // }
      
      // Like Xamarin, we do the more performant lookups MAIN_ONLY and SELF and before resorting to the slow catch-all lookup DEFAULT
      // @see https://github.com/xamarin/xamarin-macios/blob/3acfa092ddf0eccd274d9757aaaa15df7b86a516/runtime/mono-runtime.m.t4#L56
      // @see https://docs.oracle.com/cd/E88353_01/html/E37843/dlsym-3c.html
      void *value = dlsym(RTLD_MAIN_ONLY, [symbolName cStringUsingEncoding:NSUTF8StringEncoding]);
      if (!value) {
        value = dlsym(RTLD_SELF, [symbolName cStringUsingEncoding:NSUTF8StringEncoding]);
      }
      if (!value) {
        value = dlsym(RTLD_DEFAULT, [symbolName cStringUsingEncoding:NSUTF8StringEncoding]);
      }
      if(!value) {
        throw jsi::JSError(runtime, [[NSString stringWithFormat:@"ReferenceError: Can't find symbol within this executable: %@", symbolName] cStringUsingEncoding:NSUTF8StringEncoding]);
      }
      
      // dlsym() returns a pointer to the given data.
      // e.g. if we looked up `NSString* NSStringTransformToLatin`, it would return us not the NSString* directly, but a pointer to that NSString*.
      // Thus, we need to dereference it using this piece of witchcraft below.
      // @see https://stackoverflow.com/questions/23742392/how-do-i-cast-void-to-nsstring-without-getting-a-runtime-error-in-objective-c
      id valueObjc = *((__unsafe_unretained id*)value);
      
      // isKindOfClass checks whether valueObjc is an instance of any subclass of NSObject or NSObject itself.
      if(![valueObjc isKindOfClass:[NSObject class]]){
        // I don't know how to check whether an id is a selector or a protocol or whatnot, so let's just explicitly limit this to class instances.
        throw jsi::JSError(runtime, [[NSString stringWithFormat:@"TypeError: Did find the symbol named '%@', but it's not a type we can currently handle (expected a class instance). If you want a selector or a class, don't use this lookup function; instead, directly access the value off the global `objc` object.", symbolName] cStringUsingEncoding:NSUTF8StringEncoding]);
      }
      
      return jsi::Object::createFromHostObject(runtime, std::make_shared<HostObjectClassInstance>(valueObjc));
    };
    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "lookup"), 1, lookup);
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
  
  SEL selector = NSSelectorFromString(nameNSString);
  if (selector != nil) {
//    void *value = dlsym(RTLD_DEFAULT, [nameNSString cStringUsingEncoding:NSUTF8StringEncoding]);
    
    // @see https://github.com/opensource-apple/objc4/blob/master/test/cdtors.mm
    // @see https://github.com/opensource-apple/objc4/search?q=dlsym
    // id (*objc_constructInstance_fn)(Class, void*) = (id(*)(Class, void*))dlsym(RTLD_DEFAULT, [nameNSString cStringUsingEncoding:NSUTF8StringEncoding]);
    // void * (*fn)(void *) = (typeof(fn))dlsym(RTLD_DEFAULT, [nameNSString cStringUsingEncoding:NSUTF8StringEncoding]);
    // Not clear how to cast this to an objc type.
    
//    void *fn = dlsym(RTLD_DEFAULT, [nameNSString cStringUsingEncoding:NSUTF8StringEncoding]);
//    struct { void *imp; SEL sel; } message_ref = { fn, sel };
    
//    id valueObjc = (__bridge __unsafe_unretained id)value;
//    Method method = (__bridge Method)valueObjc;
//    unsigned int argsCount = method_getNumberOfArguments(method) - 2;
    
    
    throw jsi::JSError(runtime, [[NSString stringWithFormat:@"TODO"] cStringUsingEncoding:NSUTF8StringEncoding]);
    
    // return jsi::Object::createFromHostObject(runtime, std::make_unique<HostObjectSelector>(sel));
  }
  
  // Otherwise, it's a value. As far as I can see, we'll have to compile those into the app in advance from the {N} metadata.
  // strings and numbers will be fine, but there may be a small number of interop.StructType to handle as well.
  
  NSObject *value = [gObjcConstants valueForKey:nameNSString];
  return convertObjCObjectToJSIValue(runtime, value);
  
  // @see https://developer.apple.com/documentation/objectivec/objective-c_runtime?language=objc
  // @see https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html?language=objc#//apple_ref/doc/uid/TP40008048
  // @see https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Introduction/introObjectiveC.html#//apple_ref/doc/uid/TP30001163
  // From: https://www.cocoawithlove.com/2010/01/getting-subclasses-of-objective-c-class.html
  // ARC: https://stackoverflow.com/questions/8730697/using-objc-getclasslist-under-arc
}
