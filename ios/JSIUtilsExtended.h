//
//  JSIUtils.h
//  VisionCamera
//
//  Forked by Jamie Birch on 29.09.21.
//  Created by Marc Rousavy on 30.04.21.
//  Copyright © 2021 mrousavy. All rights reserved.
//  Forked from: https://github.com/mrousavy/react-native-vision-camera/blob/71730a73ef5670e45e34185a13a260a374a96dcd/ios/React%20Utils/JSIUtils.h
//

#pragma once

#import <jsi/jsi.h>
#import <ReactCommon/CallInvoker.h>
#import <React/RCTBridgeModule.h>

using namespace facebook;
using namespace facebook::react;

// NSNumber -> boolean
jsi::Value convertNSNumberToJSIBoolean(jsi::Runtime& runtime, NSNumber* value);

// NSNumber -> number
jsi::Value convertNSNumberToJSINumber(jsi::Runtime& runtime, NSNumber* value);

// NSNumber -> string
jsi::String convertNSStringToJSIString(jsi::Runtime& runtime, NSString* value);

// NSDictionary -> {}
jsi::Object convertNSDictionaryToJSIObject(jsi::Runtime& runtime, NSDictionary* value);

// NSArray -> []
jsi::Array convertNSArrayToJSIArray(jsi::Runtime& runtime, NSArray* value);

// id -> ???
jsi::Value convertObjCObjectToJSIValue(jsi::Runtime& runtime, id value);

// string -> NSString
NSString* convertJSIStringToNSString(jsi::Runtime& runtime, const jsi::String& value);

// any... -> NSArray
NSArray* convertJSICStyleArrayToNSArray(jsi::Runtime& runtime, const jsi::Value* array, size_t length, std::shared_ptr<CallInvoker> jsInvoker);

// NSArray -> any...
jsi::Value* convertNSArrayToJSICStyleArray(jsi::Runtime& runtime, NSArray* array);

// [] -> NSArray
NSArray* convertJSIArrayToNSArray(jsi::Runtime& runtime, const jsi::Array& value, std::shared_ptr<CallInvoker> jsInvoker);

// {} -> NSDictionary
NSDictionary* convertJSIObjectToNSDictionary(jsi::Runtime& runtime, const jsi::Object& value, std::shared_ptr<CallInvoker> jsInvoker);

// any -> id
id convertJSIValueToObjCObject(jsi::Runtime& runtime, const jsi::Value& value, std::shared_ptr<CallInvoker> jsInvoker);

// (any...) => any -> (void)(id, id)
RCTResponseSenderBlock convertJSIFunctionToCallback(jsi::Runtime& runtime, const jsi::Function& value, std::shared_ptr<CallInvoker> jsInvoker);
