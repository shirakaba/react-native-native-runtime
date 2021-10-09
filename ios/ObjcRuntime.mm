#import <React/RCTBridge+Private.h>
#import <React/RCTConvert.h>
#import "ObjcRuntime.h"
#import "../cpp/react-native-objc-runtime.h"

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
    ObjcRuntimeJsi::uninstall(*(facebook::jsi::Runtime *)cxxBridge.runtime);
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

RCT_EXPORT_MODULE()

@end
