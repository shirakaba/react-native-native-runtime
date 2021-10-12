// Forked from https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.mm

#import <objc/runtime.h>
#import <stdio.h>
#import <stdlib.h>
#import "ClassHostObject.h"
#import "gObjcConstants.h"
#import "JSIUtils.h"
#import <Foundation/Foundation.h>
#import <jsi/jsi.h>

ClassHostObject::ClassHostObject(Class clazz)
: clazz_(clazz) {}

ClassHostObject::~ClassHostObject() {
  Class clazz = clazz_;
}

std::vector<jsi::PropNameID> ClassHostObject::getPropertyNames(jsi::Runtime& rt) {
  std::vector<jsi::PropNameID> result;
  result.push_back(jsi::PropNameID::forUtf8(rt, std::string("toString")));
  
  // All methods for class. Should be handy.
  // @see https://www.cocoawithlove.com/2008/02/imp-of-current-method.html
  unsigned int methodCount;
  Method *methodList = class_copyMethodList(clazz_, &methodCount);
  for (unsigned int i = 0; i < methodCount; i++){
    NSString *selectorNSString = NSStringFromSelector(method_getName(methodList[i]));
    result.push_back(jsi::PropNameID::forUtf8(rt, std::string([selectorNSString UTF8String], [selectorNSString lengthOfBytesUsingEncoding:NSUTF8StringEncoding])));
  }
  free(methodList);
  
  return result;
}

jsi::Value ClassHostObject::get(jsi::Runtime& runtime, const jsi::PropNameID& propName) {
  auto name = propName.utf8(runtime);
  NSString *nameNSString = [NSString stringWithUTF8String:name.c_str()];
  
  // See also: instancesRespondToSelector, for looking up instance methods.
  SEL sel = @selector(nameNSString);
  if([clazz_ respondsToSelector:sel]){
    auto classMethod = [this, sel] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
      // @see https://jayeshkawli.ghost.io/nsinvocation-in-ios/
      // @see https://stackoverflow.com/questions/8439052/ios-how-to-implement-a-performselector-with-multiple-arguments-and-with-afterd
      NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[clazz_ methodSignatureForSelector:sel]];
      [inv setSelector:sel];
      [inv setTarget:clazz_];
      // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
      int firstArg = 2;
      for(unsigned int i = 0; i < count; i++){
        // FIXME: instead of passing NULL, pass a callInvoker.
        // We need to obtain the callInvoker in order to marshal these JSI args back to NSObject to invoke the method with, e.g.:
        //   auto callInvoker = bridge.jsCallInvoker;
        // @see https://github.com/mrousavy/react-native-vision-camera/blob/0f7ee51333c47fbfdf432c8608b9785f8eec3c94/ios/Frame%20Processor/FrameProcessorRuntimeManager.mm#L71
        // TODO: detect whether the JSI Value is a HostObject, and thus whether we need to unwrap it and retrieve the native pointer it harbours.
        id objcArg = convertJSIValueToObjCObject(runtime, arguments[i], NULL);
        [inv setArgument:&objcArg atIndex: firstArg + i];
      }
      // [clazz_ performSelector:@selector(nameNSString)];
      id returnValue = NULL;
      [inv getReturnValue:&returnValue];
      
      // Boy is this unsafe..!
      return convertObjCObjectToJSIValue(runtime, returnValue);
    };
    // FIXME: currently we're specifying an args count of 0. We have no solution for handling arbitrary numbers of args.
    // ... except, perhaps, accepting a single arg which must strictly be an array..?
    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, name), 0, classMethod);
  }
  
  return jsi::Value::undefined();
}
