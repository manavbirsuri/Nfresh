#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.

    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    FlutterMethodChannel* nativeChannel = [FlutterMethodChannel
                                           methodChannelWithName:@
                                           "flutter.native/helper"
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
