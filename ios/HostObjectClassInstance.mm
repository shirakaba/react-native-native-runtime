// Forked from https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.mm

#import <objc/runtime.h>
#import <stdio.h>
#import <stdlib.h>
#import "HostObjectClass.h"
#import "HostObjectClassInstance.h"
#import "JSIUtils.h"
#import <Foundation/Foundation.h>
#import <jsi/jsi.h>
#import <React/RCTBridge.h>
#import <React/RCTBridge+Private.h>
#import <ReactCommon/RCTTurboModule.h>
#import "HostObjectUtils.h"
#import <AVFoundation/AVFoundation.h>

HostObjectClassInstance::HostObjectClassInstance(NSObject *instance)
: instance_(instance) {}

HostObjectClassInstance::~HostObjectClassInstance() {}

std::vector<jsi::PropNameID> HostObjectClassInstance::getPropertyNames(jsi::Runtime& rt) {
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

jsi::Value HostObjectClassInstance::get(jsi::Runtime& runtime, const jsi::PropNameID& propName) {
  auto name = propName.utf8(runtime);
  NSString *nameNSString = [NSString stringWithUTF8String:name.c_str()];
  if([nameNSString isEqualToString:@"Symbol.toStringTag"]){
    // This seems to happen when you execute this JS:
    //   console.log(`objc.NSString:`, objc.NSString);
    NSString *stringification = @"[object HostObjectClassInstance]";

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
  // NSString *stringTag = [NSString stringWithFormat: @"HostObjectClassInstance<%@*>", NSStringFromClass([instance_ class])];
//  NSString *stringTag = [NSString stringWithFormat: @"HostObjectClassInstance"];
//
//  // If you implement this, it'll be used in preference over .toString().
//  if(name == "Symbol.toStringTag"){
//     return jsi::String::createFromUtf8(runtime, stringTag.UTF8String);
//  }
//
//  if(name == "Symbol.toPrimitive"){
//    return jsi::Function::createFromHostFunction(
//      runtime,
//      jsi::PropNameID::forAscii(runtime, name),
//      1,
//      [this, stringTag] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t) -> jsi::Value {
//        auto hint = arguments[0].asString(runtime).utf8(runtime);
//        if(hint == "number"){ // Handles: console.log(+hostObjectObjc);
//          return [instance_ isKindOfClass: [NSNumber class]] ?
//              convertNSNumberToJSINumber(runtime, (NSNumber *)instance_) :
//              jsi::Value(-1); // I'd prefer to return NaN here, but can't see how..!
//        } else if(hint == "string"){
//          if([instance_ isKindOfClass: [NSString class]]){
//            return convertNSStringToJSIString(runtime, (NSString *)instance_);
//          }
//        }
//        return jsi::String::createFromUtf8(runtime, [NSString stringWithFormat: @"[object %@]", stringTag].UTF8String);
//      }
//    );
//  }

  if (name == "toJS") {
    auto toJS = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
      return convertObjCObjectToJSIValue(runtime, instance_);
    };
    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "toJS"), 0, toJS);
  }
  
  // For HostObjectClassInstance, see instancesRespondToSelector, for looking up instance methods.
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
  throw jsi::JSError(runtime, "HostObjectClassInstance::get: We currently only support accesses into class instance methods and class properties.");
}

void HostObjectClassInstance::set(jsi::Runtime& runtime, const jsi::PropNameID& propName, const jsi::Value& value) {
  auto name = propName.utf8(runtime);
  NSString *nameNSString = [NSString stringWithUTF8String:name.c_str()];
  
  RCTBridge *bridge = [RCTBridge currentBridge];
  auto jsCallInvoker = bridge.jsCallInvoker;
  
  id marshalled;
  if(value.isObject()){
    jsi::Object obj = value.asObject(runtime);
    if(obj.isHostObject((runtime))){
      if(HostObjectClass* hostObjectClass = dynamic_cast<HostObjectClass*>(obj.asHostObject(runtime).get())){
        marshalled = hostObjectClass->clazz_;
      } else if(HostObjectClassInstance* hostObjectClassInstance = dynamic_cast<HostObjectClassInstance*>(obj.asHostObject(runtime).get())){
        marshalled = hostObjectClassInstance->instance_;
      } else {
        throw jsi::JSError(runtime, "invokeClassInstanceMethod: Unwrapping HostObjects other than ClassHostObject not yet supported!");
      }
    } else {
      marshalled = convertJSIValueToObjCObject(runtime, value, jsCallInvoker);
    }
  } else {
    marshalled = convertJSIValueToObjCObject(runtime, value, jsCallInvoker);
  }
  
  // @see https://stackoverflow.com/questions/29641396/how-to-get-and-set-a-property-value-with-runtime-in-objective-c/29642341
  objc_property_t property = class_getProperty([instance_ class], [nameNSString cStringUsingEncoding:NSASCIIStringEncoding]);
  
//  NSString *setterName;
//  const char* setterNameC = property_copyAttributeValue(property, "S");
//  if(setterNameC == NULL){
//    setterName = [NSString stringWithFormat: @"set%@%@:", [nameNSString substringToIndex: 1].uppercaseString, [nameNSString substringFromIndex: 1]];
//  } else {
//    setterName = [NSString stringWithCString:setterNameC encoding:NSASCIIStringEncoding];
//  }
//  SEL setterSel = sel_registerName(setterName.UTF8String);
  
  // Some properties are synthesised and thus have a backing variable, and that's what you have to call the method upon.
  // I guess if this property returns NULL, then we don't look for a backing variable at all and just use the name as-is?
  // @see https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101
  // The string starts with a T followed by the @encode type and a comma, and finishes with a V followed by the name of the backing instance variable. Between these, the attributes are specified by the following descriptors, separated by commas:
  // property_getAttributes(property) returned the following:
  // T@"AVSpeechSynthesisVoice",&,N,V_voice
  unsigned int outCount;
  objc_property_attribute_t *attributes = property_copyAttributeList(property, &outCount);
  objc_property_attribute_t finalAttribute = attributes[outCount - 1];
  const char *finalAttributeName = finalAttribute.name;
  NSLog(@"finalAttribute.name: '%s'; finalAttribute.value: '%s'", finalAttribute.name, finalAttribute.value);
  
  // Properties are typically backed by an instance variable with a leading underscore, so creating a property called firstName would have a backing instance variable with the name _firstName. You should only access that private instance variable if you override the getter/setter or if you need to setup the ivar in the class init method.
  Ivar ivar = class_getInstanceVariable([instance_ class], finalAttributeName);
  object_setIvar(instance_, ivar, marshalled);
  
  // Problem: I guess this means we skip past the setter and go straight to the backing variable, meaning
  // we side-step any (necessary) side-effects. We may need to keep looking for a better way of doing this.
  
  
////  SEL sel = NSSelectorFromString(nameNSString);
//  Method method = class_getInstanceMethod([instance_ class], setterSel);
//  NSLog(@"Checking whether the class %@ have an instance method for the setter %@...", [instance_ class], nameNSString);
//  // [instance_ performSelector:sel]
//
//  if (![instance_ respondsToSelector:setterSel]) {
//    throw jsi::JSError(runtime, [[NSString stringWithFormat:@"TypeError: No such setter: %@", nameNSString] cStringUsingEncoding:NSUTF8StringEncoding]);
//  }
//
//  invokeClassInstanceMethod(runtime, [setterName cStringUsingEncoding:NSUTF8StringEncoding], setterSel, instance_);
//
//  // [instance_ perf]
//
//  // TODO: implement the setter itself
//  // ((void (*) (id,SEL,id)) objc_msgSend) (instance_,sel,marshalled);
}
