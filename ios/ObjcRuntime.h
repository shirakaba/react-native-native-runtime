#import <React/RCTBridgeModule.h>

@interface ObjcRuntime : NSObject <RCTBridgeModule>
@property (nonatomic, assign) BOOL setBridgeOnMainQueue;
@end
