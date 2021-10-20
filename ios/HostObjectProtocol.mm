// Forked from https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.mm

#import <objc/runtime.h>
#import <stdio.h>
#import <stdlib.h>
#import "HostObjectProtocol.h"
#import "JSIUtils.h"
#import <Foundation/Foundation.h>
#import <jsi/jsi.h>
#import <React/RCTBridge.h>
#import <React/RCTBridge+Private.h>
#import <ReactCommon/RCTTurboModule.h>
#import "HostObjectUtils.h"

HostObjectProtocol::HostObjectProtocol(Protocol *protocol)
: protocol_(protocol) {}

HostObjectProtocol::~HostObjectProtocol() {}

std::vector<jsi::PropNameID> HostObjectProtocol::getPropertyNames(jsi::Runtime& rt) {
  std::vector<jsi::PropNameID> result;
  result.push_back(jsi::PropNameID::forUtf8(rt, std::string("toString")));
  
  return result;
}

jsi::Value HostObjectProtocol::get(jsi::Runtime& runtime, const jsi::PropNameID& propName) {
  auto name = propName.utf8(runtime);
  NSString *nameNSString = [NSString stringWithUTF8String:name.c_str()];
  if([nameNSString isEqualToString:@"Symbol.toStringTag"]){
    NSString *stringification = @"[object HostObjectProtocol]";
    return jsi::String::createFromUtf8(runtime, stringification.UTF8String);
  }
  
  throw jsi::JSError(runtime, "HostObjectProtocol::get: Mostly unimplemented.");
}
