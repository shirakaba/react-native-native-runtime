/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <react-native-objc-runtime/gObjcConstants.h>

#ifdef FB_SONARKIT_ENABLED
#import <FlipperKit/FlipperClient.h>
#import <FlipperKitLayoutPlugin/FlipperKitLayoutPlugin.h>
#import <FlipperKitUserDefaultsPlugin/FKUserDefaultsPlugin.h>
#import <FlipperKitNetworkPlugin/FlipperKitNetworkPlugin.h>
#import <SKIOSNetworkPlugin/SKIOSNetworkAdapter.h>
#import <FlipperKitReactPlugin/FlipperKitReactPlugin.h>
static void InitializeFlipper(UIApplication *application) {
  FlipperClient *client = [FlipperClient sharedClient];
  SKDescriptorMapper *layoutDescriptorMapper = [[SKDescriptorMapper alloc] initWithDefaults];
  [client addPlugin:[[FlipperKitLayoutPlugin alloc] initWithRootNode:application withDescriptorMapper:layoutDescriptorMapper]];
  [client addPlugin:[[FKUserDefaultsPlugin alloc] initWithSuiteName:nil]];
  [client addPlugin:[FlipperKitReactPlugin new]];
  [client addPlugin:[[FlipperKitNetworkPlugin alloc] initWithNetworkAdapter:[SKIOSNetworkAdapter new]]];
  [client start];
}
#endif

@implementation AppDelegate

-(NSDictionary *)readObjcConstants:(NSString *)subdirectory
{
  NSArray<NSURL*> *urls = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"json" subdirectory:subdirectory];
  NSLog(@"Got urls: %@", urls);
  
  NSMutableDictionary *constants = [[NSMutableDictionary alloc] init];
  
  [urls enumerateObjectsUsingBlock:^(NSURL * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop){
    NSError *error = NULL;
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    if(error != NULL){
      [NSException raise:@"Failed to read objc-constants file" format:@"Failed to read objc-constants file '%@'. Error: %@", url.path, error.localizedDescription];
    }
    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != NULL)
    {
      [NSException raise:@"Failed to parse objc-constants file" format:@"Failed to parse objc-constants file '%@'. Error: %@", url.path, error.localizedDescription];
    }
    if(![json isKindOfClass:[NSDictionary class]])
    {
      [NSException raise:@"Failed to marshal objc-constants file" format:@"Failed to marshal objc-constants file '%@' to NSDictionary.", error.localizedDescription];
    }
    
    [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
      [constants setValue:obj forKey:(NSString*)key];
    }];
  }];
  
  return constants;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  #ifdef FB_SONARKIT_ENABLED
    InitializeFlipper(application);
  #endif
  gObjcConstants = [self readObjcConstants:@"objc-constants"];
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"ObjcRuntimeExample"
                                            initialProperties:nil];
  if (@available(iOS 13.0, *)) {
    rootView.backgroundColor = [UIColor systemBackgroundColor];
  } else {
    rootView.backgroundColor = [UIColor redColor];
  }

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
