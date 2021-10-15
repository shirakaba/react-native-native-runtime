#import <React/RCTBridge+Private.h>
#import <React/RCTConvert.h>
#import "ObjcRuntime.h"
#import "react-native-objc-runtime.h"

// This is the entrypoint file for our native module.
// It will be called by React Native as it initialises its native modules.

@implementation ObjcRuntime

@synthesize bridge=_bridge;

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

- (void)setBridge:(RCTBridge *)bridge {
  _bridge = bridge;
  _setBridgeOnMainQueue = RCTIsMainQueue();

  RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self.bridge;
  if (!cxxBridge.runtime) {
    return;
  }
  
  // Install the `objc` HostObject into the JS runtime in global scope.
  ObjcRuntimeJsi::install(*(facebook::jsi::Runtime *)cxxBridge.runtime);
}

- (void)invalidate {
  if(!self.bridge){
    return;
  }
  RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self.bridge;
  if (!cxxBridge.runtime) {
    return;
  }
  
  // Overwrite the `objc` HostObject as undefined (my speculative way of cleaning it up).
  ObjcRuntimeJsi::uninstall(*(facebook::jsi::Runtime *)cxxBridge.runtime);
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

RCT_EXPORT_MODULE()

@end
