// Forked from https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.mm

#import <objc/runtime.h>
#import <stdio.h>
#import <stdlib.h>
#import "gObjcConstants.h"
#import "JSIUtils.h"
#import <Foundation/Foundation.h>
#import <jsi/jsi.h>
#import <React/RCTBridge.h>
#import <React/RCTBridge+Private.h>
#import <ReactCommon/RCTTurboModule.h>
#import "HostObjectClass.h"
#import "HostObjectClassInstance.h"
#import "HostObjectUtils.h"

HostObjectClass::HostObjectClass(Class clazz)
: clazz_(clazz) {}

HostObjectClass::~HostObjectClass() {
  Class clazz = clazz_;
}

std::vector<jsi::PropNameID> HostObjectClass::getPropertyNames(jsi::Runtime& rt) {
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

jsi::Value HostObjectClass::get(jsi::Runtime& runtime, const jsi::PropNameID& propName) {
  auto name = propName.utf8(runtime);
  NSString *nameNSString = [NSString stringWithUTF8String:name.c_str()];
  if([nameNSString isEqualToString:@"Symbol.toStringTag"]){
    // This seems to happen when you execute this JS:
    //   console.log(`objc.NSString:`, objc.NSString);
    NSString *stringification = @"[object HostObjectClass]";
    
    return jsi::String::createFromUtf8(runtime, stringification.UTF8String);
  }
  
  // For HostObjectClassInstance, see instancesRespondToSelector, for looking up instance methods.
  SEL sel = NSSelectorFromString(nameNSString);
  if([clazz_ respondsToSelector:sel]){
    return invokeClassMethod(runtime, name, sel, clazz_);
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
  throw jsi::JSError(runtime, "HostObjectClass::get: We currently only support accesses into class methods and class fields.");
  
  // return jsi::Value::undefined();
}
