#import <objc/runtime.h>
#import "JSIUtils.h"
#import <Foundation/Foundation.h>
#import <jsi/jsi.h>
#import <React/RCTBridge.h>
#import <React/RCTBridge+Private.h>
#import <ReactCommon/RCTTurboModule.h>
#import <ReactCommon/CallInvoker.h>
#import <React/RCTBridge.h>
#import <ReactCommon/TurboModuleUtils.h>
#import "HostObjectClass.h"
#import "HostObjectClassInstance.h"

using namespace facebook;
using namespace facebook::react;
// FIXME: upon several fast refreshes, I found that our NSString instance (held by HostObjectClassInstance) had become
// nil at the time of calling 'stringByApplyingTransform:reverse:'.
// This likely indicates that nothing's keeping a strong reference to it.
jsi::Function invokeClassInstanceMethod(jsi::Runtime &runtime, std::string methodName, SEL sel, NSObject *instance)
{
  Method method = class_getInstanceMethod([instance class], sel);
  if(!method){
    throw jsi::JSError(runtime, "invokeClassInstanceMethod: class instance responded to selector, but the corresponding method was unable to be retrieved.");
  }
  char observedReturnType[256];
  method_getReturnType(method, observedReturnType, 256);
  
  // TODO: refactor redundant code between invokeClassInstanceMethod and invokeClassMethod
  
  // Not sure yet how we'll handle varargs, but if it comes to it, we can change approach to enforce a single argument which is strictly an array.
  // arguments 0 and 1 are self and _cmd respectively (effectively not of our concern)
  unsigned int reservedArgs = 2;
  unsigned int argsCount = method_getNumberOfArguments(method) - reservedArgs;
  auto classMethod = [reservedArgs, instance, sel, observedReturnType] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
    RCTBridge *bridge = [RCTBridge currentBridge];
    auto jsCallInvoker = bridge.jsCallInvoker;
    // @see https://stackoverflow.com/questions/313400/nsinvocation-for-dummies
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[instance class] instanceMethodSignatureForSelector:sel]];
    [inv setSelector:sel];
    [inv setTarget:instance];
    for(unsigned int i = 0; i < count; i++){
      // @see https://github.com/mrousavy/react-native-vision-camera/blob/0f7ee51333c47fbfdf432c8608b9785f8eec3c94/ios/Frame%20Processor/FrameProcessorRuntimeManager.mm#L71
      if(arguments[i].isObject()){
        jsi::Object obj = arguments[i].asObject(runtime);
        if(obj.isHostObject((runtime))){
          if(HostObjectClass* hostObjectClass = dynamic_cast<HostObjectClass*>(obj.asHostObject(runtime).get())){
            [inv setArgument:&hostObjectClass->clazz_ atIndex: reservedArgs + i];
          } else if(HostObjectClassInstance* hostObjectClassInstance = dynamic_cast<HostObjectClassInstance*>(obj.asHostObject(runtime).get())){
            [inv setArgument:&hostObjectClassInstance->instance_ atIndex: reservedArgs + i];
          } else {
            throw jsi::JSError(runtime, "invokeClassInstanceMethod: Unwrapping HostObjects other than ClassHostObject not yet supported!");
          }
        } else {
          id objcArg = convertJSIValueToObjCObject(runtime, arguments[i], jsCallInvoker);
          [inv setArgument:&objcArg atIndex: reservedArgs + i];
        }
      } else {
        id objcArg = convertJSIValueToObjCObject(runtime, arguments[i], jsCallInvoker);
        [inv setArgument:&objcArg atIndex: reservedArgs + i];
      }
    }
    [inv invoke];
    
    // @see https://developer.apple.com/documentation/foundation/nsmethodsignature
    const char *voidReturnType = "v";
    if(0 == strncmp(observedReturnType, voidReturnType, strlen(voidReturnType))){
      return jsi::Value::undefined();
    }
    
    id returnValue = NULL;
    [inv getReturnValue:&returnValue];
    
    // isKindOfClass checks whether the returnValue is an instance of any subclass of NSObject or NSObject itself.
    // There is also isMemberOfClass if we ever want to check whether it is an instance of NSObject (not a subclass).
    if([returnValue isKindOfClass:[NSObject class]]){
      return jsi::Object::createFromHostObject(runtime, std::make_shared<HostObjectClassInstance>(returnValue));
    }
    
    // If we get blocked by "Did you forget to nest alloc and init?", we may be restricted to [NSString new].
    
    // Boy is this unsafe..!
    return convertObjCObjectToJSIValue(runtime, returnValue);
  };
  return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, methodName), argsCount, classMethod);
}

jsi::Function invokeClassMethod(jsi::Runtime &runtime, std::string methodName, SEL sel, Class clazz)
{
  Method method = class_getClassMethod(clazz, sel);
  if(!method){
    throw jsi::JSError(runtime, "invokeClassMethod: class responded to selector, but the corresponding method was unable to be retrieved. Perhaps it's an instance method? On classes, you can only call class methods.");
  }
  
  // Not sure yet how we'll handle varargs, but if it comes to it, we can change approach to enforce a single argument which is strictly an array.
  // arguments 0 and 1 are self and _cmd respectively (effectively not of our concern)
  unsigned int reservedArgs = 2;
  unsigned int argsCount = method_getNumberOfArguments(method) - reservedArgs;
  auto classMethod = [reservedArgs, clazz, sel] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
    RCTBridge *bridge = [RCTBridge currentBridge];
    auto jsCallInvoker = bridge.jsCallInvoker;
    // @see https://jayeshkawli.ghost.io/nsinvocation-in-ios/
    // @see https://stackoverflow.com/questions/8439052/ios-how-to-implement-a-performselector-with-multiple-arguments-and-with-afterd
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[clazz methodSignatureForSelector:sel]];
    [inv setSelector:sel];
    [inv setTarget:clazz];
    for(unsigned int i = 0; i < count; i++){
      // @see https://github.com/mrousavy/react-native-vision-camera/blob/0f7ee51333c47fbfdf432c8608b9785f8eec3c94/ios/Frame%20Processor/FrameProcessorRuntimeManager.mm#L71
      if(arguments[i].isObject()){
        jsi::Object obj = arguments[i].asObject(runtime);
        if(obj.isHostObject((runtime))){
          if(HostObjectClass* hostObjectClass = dynamic_cast<HostObjectClass*>(obj.asHostObject(runtime).get())){
            [inv setArgument:&hostObjectClass->clazz_ atIndex: reservedArgs + i];
          } else if(HostObjectClassInstance* hostObjectClassInstance = dynamic_cast<HostObjectClassInstance*>(obj.asHostObject(runtime).get())){
            [inv setArgument:&hostObjectClassInstance->instance_ atIndex: reservedArgs + i];
          } else {
            throw jsi::JSError(runtime, "invokeClassMethod: Unwrapping HostObjects other than HostObjectClass not yet supported!");
          }
        } else {
          id objcArg = convertJSIValueToObjCObject(runtime, arguments[i], jsCallInvoker);
          [inv setArgument:&objcArg atIndex: reservedArgs + i];
        }
      } else {
        id objcArg = convertJSIValueToObjCObject(runtime, arguments[i], jsCallInvoker);
        [inv setArgument:&objcArg atIndex: reservedArgs + i];
      }
    }
    [inv invoke];
    id returnValue = NULL;
    [inv getReturnValue:&returnValue];
    
    // isKindOfClass checks whether the returnValue is an instance of any subclass of NSObject or NSObject itself.
    // There is also isMemberOfClass if we ever want to check whether it is an instance of NSObject (not a subclass).
    if([returnValue isKindOfClass:[NSObject class]]){
      return jsi::Object::createFromHostObject(runtime, std::make_shared<HostObjectClassInstance>(returnValue));
    }
    
    // If we get blocked by "Did you forget to nest alloc and init?", we may be restricted to [NSString new].
    
    // Boy is this unsafe..!
    return convertObjCObjectToJSIValue(runtime, returnValue);
  };
  return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, methodName), argsCount, classMethod);
}
