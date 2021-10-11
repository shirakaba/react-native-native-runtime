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
  
  // FIXME: This performs the selector, without any arguments, upon a get access.
  // Change this so that we'd do this only upon invocations instead, and use any arguments passed in.
  if([[clazz_ class] respondsToSelector:@selector(nameNSString)]){
    id returnValue = [[clazz_ class] performSelector:@selector(nameNSString)];
    // Boy is this unsafe..!
    return convertObjCObjectToJSIValue(runtime, returnValue);
  }
  
  return jsi::Value::undefined();
}
