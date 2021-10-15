// Forked from https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.mm

#import <objc/runtime.h>
#import <stdio.h>
#import <stdlib.h>
#import "ClassHostObject.h"
#import "gObjcConstants.h"
#import "JSIUtils.h"
#import <Foundation/Foundation.h>
#import <jsi/jsi.h>
#import <React/RCTBridge.h>
#import <React/RCTBridge+Private.h>
#import <ReactCommon/RCTTurboModule.h>
#import "ClassInstanceHostObject.h"

ClassHostObject::ClassHostObject(Class clazz)
: clazz_(clazz) {}

ClassHostObject::~ClassHostObject() {
  Class clazz = clazz_;
}

std::vector<jsi::PropNameID> ClassHostObject::getPropertyNames(jsi::Runtime& rt) {
  std::vector<jsi::PropNameID> result;
  result.push_back(jsi::PropNameID::forUtf8(rt, std::string("toString")));
  
  // All class methods
  // @see https://www.cocoawithlove.com/2008/02/imp-of-current-method.html
  // @see https://stackoverflow.com/questions/2094702/get-all-methods-of-an-objective-c-class-or-instance
  unsigned int methodCount;
  Method *methodList = class_copyMethodList(object_getClass(clazz_), &methodCount);
  for (unsigned int i = 0; i < methodCount; i++){
    NSString *selectorNSString = NSStringFromSelector(method_getName(methodList[i]));
    result.push_back(jsi::PropNameID::forUtf8(rt, std::string([selectorNSString UTF8String], [selectorNSString lengthOfBytesUsingEncoding:NSUTF8StringEncoding])));
  }
  free(methodList);
  
  // TODO: copy all methods of any subclasses too.
    
//  // Copy properties for this instance's class. I think this means instance fields
//  unsigned int propertyCount;
//  objc_property_t _Nonnull *propertyList = class_copyPropertyList(clazz_, &propertyCount);
//  for (unsigned int i = 0; i < propertyCount; i++){
//    NSString *propertyNSString = [NSString stringWithUTF8String:property_getName(propertyList[i])];
//    result.push_back(jsi::PropNameID::forUtf8(rt, std::string([propertyNSString UTF8String], [propertyNSString lengthOfBytesUsingEncoding:NSUTF8StringEncoding])));
//  }
//  free(propertyList);
  
  return result;
}

jsi::Value ClassHostObject::get(jsi::Runtime& runtime, const jsi::PropNameID& propName) {
  auto name = propName.utf8(runtime);
  NSString *nameNSString = [NSString stringWithUTF8String:name.c_str()];
  if([nameNSString isEqualToString:@"Symbol.toStringTag"]){
    // This seems to happen when you execute this JS:
    //   console.log(`objc.NSString:`, objc.NSString);
    NSString *stringification = @"[object ClassHostObject]";
    
    return jsi::String::createFromUtf8(runtime, stringification.UTF8String);
  }
  
  // For ClassInstanceHostObject, see instancesRespondToSelector, for looking up instance methods.
  SEL sel = NSSelectorFromString(nameNSString);
  if([clazz_ respondsToSelector:sel]){
    Method method = class_getClassMethod(clazz_, sel);
    if(!method){
      throw jsi::JSError(runtime, "ClassHostObject::get: class responded to selector, but the corresponding method was unable to be retrieved. Perhaps it's an instance method? On classes, you can only call class methods.");
    }
    // Not sure yet how we'll handle varargs, but if it comes to it, we can change approach to enforce a single argument which is strictly an array.
    unsigned int argsCount = method_getNumberOfArguments(method);
    auto classMethod = [this, sel] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
      RCTBridge *bridge = [RCTBridge currentBridge];
      auto jsCallInvoker = bridge.jsCallInvoker;
      // @see https://jayeshkawli.ghost.io/nsinvocation-in-ios/
      // @see https://stackoverflow.com/questions/8439052/ios-how-to-implement-a-performselector-with-multiple-arguments-and-with-afterd
      NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[clazz_ methodSignatureForSelector:sel]];
      [inv setSelector:sel];
      [inv setTarget:clazz_];
      // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
      int firstArgIndex = 2;
      for(unsigned int i = 0; i < count; i++){
        // @see https://github.com/mrousavy/react-native-vision-camera/blob/0f7ee51333c47fbfdf432c8608b9785f8eec3c94/ios/Frame%20Processor/FrameProcessorRuntimeManager.mm#L71
        if(arguments[i].isObject()){
          jsi::Object obj = arguments[i].asObject(runtime);
          if(obj.isHostObject((runtime))){
            if(ClassHostObject* classHostObj = dynamic_cast<ClassHostObject*>(obj.asHostObject(runtime).get())){
              [inv setArgument:&classHostObj->clazz_ atIndex: firstArgIndex + i];
            } else if(ClassInstanceHostObject* classInstanceHostObj = dynamic_cast<ClassInstanceHostObject*>(obj.asHostObject(runtime).get())){
              [inv setArgument:&classInstanceHostObj->instance_ atIndex: firstArgIndex + i];
            } else {
              // TODO: detect whether the JSI Value is a HostObject, and thus whether we need to unwrap it and retrieve the native pointer it harbours.
              throw jsi::JSError(runtime, "ClassHostObject::get: Unwrapping HostObjects other than ClassHostObject not yet supported!");
            }
          } else {
            id objcArg = convertJSIValueToObjCObject(runtime, arguments[i], jsCallInvoker);
            [inv setArgument:&objcArg atIndex: firstArgIndex + i];
          }
        } else {
          id objcArg = convertJSIValueToObjCObject(runtime, arguments[i], jsCallInvoker);
          [inv setArgument:&objcArg atIndex: firstArgIndex + i];
        }
      }
      [inv invoke];
      id returnValue = NULL;
      [inv getReturnValue:&returnValue];
      
      // FIXME: In the case of NSString.alloc(), returnValue is an NSPlaceholderString.
      // It can't be converted directly into a JSI value; it needs to be wrapped into a HostObject first, then returned.
      
      // Boy is this unsafe..!
      return convertObjCObjectToJSIValue(runtime, returnValue);
    };
    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, name), argsCount, classMethod);
  }
  
  objc_property_t property = class_getProperty(clazz_, nameNSString.UTF8String);
  if(property){
    const char *propertyName = property_getName(property);
    if(propertyName){
      NSObject* value = [clazz_ valueForKey:[NSString stringWithUTF8String:propertyName]];
      return convertObjCObjectToJSIValue(runtime, value);
    }
  }
  
  // Next, handle things other than class methods.
  throw jsi::JSError(runtime, "ClassHostObject::get: We currently only support accesses into class methods and class fields.");
  
  // return jsi::Value::undefined();
}
