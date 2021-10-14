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
  
  // See also: instancesRespondToSelector, for looking up instance methods.
  SEL sel = @selector(nameNSString);
//  if([clazz_ respondsToSelector:sel]){
//    auto classMethod = [this, sel] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      RCTBridge *bridge = [RCTBridge currentBridge];
//      auto jsCallInvoker = bridge.jsCallInvoker;
//      // @see https://jayeshkawli.ghost.io/nsinvocation-in-ios/
//      // @see https://stackoverflow.com/questions/8439052/ios-how-to-implement-a-performselector-with-multiple-arguments-and-with-afterd
//      NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[clazz_ methodSignatureForSelector:sel]];
//      [inv setSelector:sel];
//      [inv setTarget:clazz_];
//      // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
//      int firstArgIndex = 2;
//      for(unsigned int i = 0; i < count; i++){
//        // @see https://github.com/mrousavy/react-native-vision-camera/blob/0f7ee51333c47fbfdf432c8608b9785f8eec3c94/ios/Frame%20Processor/FrameProcessorRuntimeManager.mm#L71
//        if(arguments[i].isObject()){
//          jsi::Object obj = arguments[i].asObject(runtime);
//          if(obj.isHostObject((runtime))){
//            if(ClassInstanceHostObject* classHostObj = dynamic_cast<ClassInstanceHostObject*>(obj.asHostObject(runtime).get())) {
//              [inv setArgument:&classHostObj->clazz_ atIndex: firstArgIndex + i];
//            } else {
//              // TODO: detect whether the JSI Value is a HostObject, and thus whether we need to unwrap it and retrieve the native pointer it harbours.
//              throw jsi::JSError(runtime, "ClassInstanceHostObject::get: Unwrapping HostObjects other than ClassInstanceHostObject not yet supported!");
//            }
//          } else {
//            id objcArg = convertJSIValueToObjCObject(runtime, arguments[i], jsCallInvoker);
//            [inv setArgument:&objcArg atIndex: firstArgIndex + i];
//          }
//        } else {
//          id objcArg = convertJSIValueToObjCObject(runtime, arguments[i], jsCallInvoker);
//          [inv setArgument:&objcArg atIndex: firstArgIndex + i];
//        }
//      }
//      id returnValue = NULL;
//      [inv getReturnValue:&returnValue];
//
//      // Boy is this unsafe..!
//      return convertObjCObjectToJSIValue(runtime, returnValue);
//    };
//    // FIXME: currently we're specifying an args count of 0. We have no solution for handling arbitrary numbers of args.
//    // ... except, perhaps, accepting a single arg which must strictly be an array..?
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, name), 0, classMethod);
//  }
  
  return jsi::Value::undefined();
}
