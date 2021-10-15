// Forked from https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.mm

#import <objc/runtime.h>
#import <stdio.h>
#import <stdlib.h>
#import "ClassInstanceHostObject.h"
#import "gObjcConstants.h"
#import "JSIUtils.h"
#import <Foundation/Foundation.h>
#import <jsi/jsi.h>
#import <React/RCTBridge.h>
#import <React/RCTBridge+Private.h>
#import <ReactCommon/RCTTurboModule.h>
#import "HostObjectUtils.h"

ClassInstanceHostObject::ClassInstanceHostObject(NSObject *instance)
: instance_(instance) {}

ClassInstanceHostObject::~ClassInstanceHostObject() {
  NSObject *instance = instance_;
}

std::vector<jsi::PropNameID> ClassInstanceHostObject::getPropertyNames(jsi::Runtime& rt) {
  std::vector<jsi::PropNameID> result;
  result.push_back(jsi::PropNameID::forUtf8(rt, std::string("toString")));
  
  // Copy instance methods.
  // @see https://www.cocoawithlove.com/2008/02/imp-of-current-method.html
  // @see https://stackoverflow.com/questions/2094702/get-all-methods-of-an-objective-c-class-or-instance
  unsigned int methodCount;
  Method *methodList = class_copyMethodList([instance_ class], &methodCount);
  for (unsigned int i = 0; i < methodCount; i++){
    NSString *selectorNSString = NSStringFromSelector(method_getName(methodList[i]));
    result.push_back(jsi::PropNameID::forUtf8(rt, std::string([selectorNSString UTF8String], [selectorNSString lengthOfBytesUsingEncoding:NSUTF8StringEncoding])));
  }
  free(methodList);
  
  // Copy properties for this instance's class.
  unsigned int propertyCount;
  objc_property_t _Nonnull *propertyList = class_copyPropertyList(object_getClass(instance_), &propertyCount);
  for (unsigned int i = 0; i < propertyCount; i++){
    property_getName(propertyList[i]);
    NSString *propertyNSString = [NSString stringWithUTF8String:property_getName(propertyList[i])];
    result.push_back(jsi::PropNameID::forUtf8(rt, std::string([propertyNSString UTF8String], [propertyNSString lengthOfBytesUsingEncoding:NSUTF8StringEncoding])));
  }
  free(propertyList);
  
  // Copy ivars for this instance.
  unsigned int ivarCount;
  Ivar  _Nonnull *ivarList = class_copyIvarList([instance_ class], &ivarCount);
  for (unsigned int i = 0; i < ivarCount; i++){
    NSString *ivarNSString = [NSString stringWithUTF8String:ivar_getName(ivarList[i])];
    result.push_back(jsi::PropNameID::forUtf8(rt, std::string([ivarNSString UTF8String], [ivarNSString lengthOfBytesUsingEncoding:NSUTF8StringEncoding])));
  }
  free(propertyList);
  
  // TODO: do the same for subclasses, too.
  
  return result;
}

jsi::Value ClassInstanceHostObject::get(jsi::Runtime& runtime, const jsi::PropNameID& propName) {
  auto name = propName.utf8(runtime);
  NSString *nameNSString = [NSString stringWithUTF8String:name.c_str()];
  if([nameNSString isEqualToString:@"Symbol.toStringTag"]){
    // This seems to happen when you execute this JS:
    //   console.log(`objc.NSString:`, objc.NSString);
    NSString *stringification = @"[object ClassInstanceHostObject]";
    
    return jsi::String::createFromUtf8(runtime, stringification.UTF8String);
  }
  
  if([nameNSString isEqualToString:@"$$typeof"]){
    // This seems to happen when you execute this JS:
    //   const nsString = objc.NSString.alloc();
    //   console.log(`nsString:`, nsString);
    // FIXME: My approach here seems to be incorrect, as it puts us into an infinite loop of (approximately):
    // $$typeof -> Symbol.toStringTag -> toJSON -> Symbol.toStringTag -> Symbol.toStringTag -> Symbol.toStringTag -> Symbol.toStringTag -> toString
    NSString *stringification = NSStringFromClass([instance_ class]);
    return jsi::String::createFromUtf8(runtime, stringification.UTF8String);
  }
  
  // For ClassInstanceHostObject, see instancesRespondToSelector, for looking up instance methods.
  SEL sel = NSSelectorFromString(nameNSString);
  if([instance_ respondsToSelector:sel]){
    return invokeClassInstanceMethod(runtime, name, sel, instance_);
  }
  
  objc_property_t property = class_getProperty([instance_ class], nameNSString.UTF8String);
  if(property){
    const char *propertyName = property_getName(property);
    if(propertyName){
      NSObject* value = [instance_ valueForKey:[NSString stringWithUTF8String:propertyName]];
      return convertObjCObjectToJSIValue(runtime, value);
    }
  }
  
  // Next, handle things other than class methods.
  throw jsi::JSError(runtime, "ClassInstanceHostObject::get: We currently only support accesses into class instance methods and class properties.");
  
  // return jsi::Value::undefined();
}
