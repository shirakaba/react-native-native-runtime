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
#import "ClassHostObject.h"
#import "ClassInstanceHostObject.h"

using namespace facebook;
using namespace facebook::react;

jsi::Function invokeClassMethod(jsi::Runtime &runtime, std::string methodName, SEL sel, Class clazz)
{
  Method method = class_getClassMethod(clazz, sel);
  if(!method){
    throw jsi::JSError(runtime, "ClassHostObject::get: class responded to selector, but the corresponding method was unable to be retrieved. Perhaps it's an instance method? On classes, you can only call class methods.");
  }
  // Not sure yet how we'll handle varargs, but if it comes to it, we can change approach to enforce a single argument which is strictly an array.
  unsigned int argsCount = method_getNumberOfArguments(method);
  auto classMethod = [clazz, sel] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
    RCTBridge *bridge = [RCTBridge currentBridge];
    auto jsCallInvoker = bridge.jsCallInvoker;
    // @see https://jayeshkawli.ghost.io/nsinvocation-in-ios/
    // @see https://stackoverflow.com/questions/8439052/ios-how-to-implement-a-performselector-with-multiple-arguments-and-with-afterd
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[clazz methodSignatureForSelector:sel]];
    [inv setSelector:sel];
    [inv setTarget:clazz];
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
    
    // isKindOfClass checks whether the returnValue is an instance of any subclass of NSObject or NSObject itself.
    // There is also isMemberOfClass if we ever want to check whether it is an instance of NSObject (not a subclass).
    if([returnValue isKindOfClass:[NSObject class]]){
      return jsi::Object::createFromHostObject(runtime, std::make_shared<ClassInstanceHostObject>(returnValue));
    }
    
    // If we get blocked by "Did you forget to nest alloc and init?", we may be restricted to [NSString new].
    
    // Boy is this unsafe..!
    return convertObjCObjectToJSIValue(runtime, returnValue);
  };
  return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, methodName), argsCount, classMethod);
}
