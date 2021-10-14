// Forked from https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.mm

#import <objc/runtime.h>
#import <stdio.h>
#import <stdlib.h>
#import "ObjCHostObject.h"
#import "gObjcConstants.h"
#import "JSIUtils.h"
#import <Foundation/Foundation.h>
#import <jsi/jsi.h>

std::vector<jsi::PropNameID> ObjCHostObject::getPropertyNames(jsi::Runtime& rt) {
  std::vector<jsi::PropNameID> result;
  result.push_back(jsi::PropNameID::forUtf8(rt, std::string("toString")));
  return result;
}

jsi::Value ObjCHostObject::get(jsi::Runtime& runtime, const jsi::PropNameID& propName) {
  auto name = propName.utf8(runtime);
  NSString* nameNSString = [NSString stringWithUTF8String:name.c_str()];

  if (name == "toString") {
    auto toString = [this] (jsi::Runtime& runtime, const jsi::Value&, const jsi::Value*, size_t) -> jsi::Value {
      NSString* string = [NSString stringWithFormat:@"objc"];
      return jsi::String::createFromUtf8(runtime, string.UTF8String);
    };
    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "toString"), 0, toString);
  }
  
  // @see https://developer.apple.com/documentation/foundation/object_runtime/objective-c_runtime_utilities?language=objc
  Class clazz = NSClassFromString(nameNSString);
  if (clazz != nil) {
    // TODO: support classes
    return jsi::Value::undefined();
  }
  
  Protocol *protocol = NSProtocolFromString(nameNSString);
  if (protocol != nil) {
    // TODO: support protocols
    return jsi::Value::undefined();
  }
  
  SEL selector = NSSelectorFromString(nameNSString);
  if (selector != nil) {
    // TODO: support selectors
    return jsi::Value::undefined();
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
