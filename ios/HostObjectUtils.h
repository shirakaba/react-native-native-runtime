#pragma once

#import <jsi/jsi.h>
#import <ReactCommon/CallInvoker.h>
#import <React/RCTBridgeModule.h>

using namespace facebook;
using namespace facebook::react;

// Returns a jsi::Function that, when called, will:
// - invoke a class method with the given selector on the given class
// - capture its return value
// - marshals it to a JSI Object (either a jsi::Value or a jsi::HostObject as appropriate).
jsi::Function invokeClassMethod(jsi::Runtime &runtime, std::string methodName, SEL sel, Class clazz);
