#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include <Firebase.h>

@implementation AppDelegate

/*- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.

    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    //FlutterMethodChannel* nativeChannel = [FlutterMethodChannel
                                           methodChannelWithName:@
                                           "flutter.native/helper"
   return [super application:application didFinishLaunchingWithOptions:launchOptions];
}*/

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   // [Fabric with:@[[Crashlytics class]]];
    
  //  [FIRAnalytics setAnalyticsCollectionEnabled:YES];
    
    [FIRApp configure];
    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    FlutterMethodChannel* nativeChannel = [FlutterMethodChannel
                                           methodChannelWithName:@"flutter.native/helper"
                                           binaryMessenger:controller];
    __weak  typeof(self) weakSelf = self;
    [nativeChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        
        NSString *strNative = call.method;
        
        NSArray *arr = [strNative componentsSeparatedByString:@"::"];
        
        NSMutableDictionary *dictInfo = [NSJSONSerialization JSONObjectWithData:[arr[1] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
     
        [self beginPayment:dictInfo checkSum:arr[0]];
        
       /* if ([@"helloFromNativeCode"  isEqualToString:call.method]) {
            NSString *strNative = [weakSelf helloFromNativeCode];
            result(strNative);
            [self beginPayment];
        } else {
            result(FlutterMethodNotImplemented);
        }*/
    }];
    [GeneratedPluginRegistrant  registerWithRegistry:self];
    return [super  application:application didFinishLaunchingWithOptions:launchOptions];
}
- (NSString *)helloFromNativeCode {
    return  @"Hello From Native IOS Code";
    
    //[GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    //return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)beginPayment:(NSDictionary *)dictInfo checkSum:(NSString *)strCheckSum {
    PGOrder *order = [PGOrder orderForOrderID:@""
                                   customerID:@""
                                       amount:@""
                                 customerMail:@""
                               customerMobile:@""];
    order.params =   @{@"MID" : [dictInfo valueForKey:@"MID"],
                       @"ORDER_ID": [dictInfo valueForKey:@"ORDER_ID"],
                       @"CUST_ID" : [dictInfo valueForKey:@"CUST_ID"],
                       @"MOBILE_NO" : [dictInfo valueForKey:@"MOBILE_NO"],
                       @"EMAIL" : [dictInfo valueForKey:@"EMAIL"],
                       @"CHANNEL_ID": [dictInfo valueForKey:@"CHANNEL_ID"],
                       @"WEBSITE": [dictInfo valueForKey:@"WEBSITE"],
                       @"TXN_AMOUNT": [dictInfo valueForKey:@"TXN_AMOUNT"],
                       @"INDUSTRY_TYPE_ID": [dictInfo valueForKey:@"INDUSTRY_TYPE_ID"],
                       @"CHECKSUMHASH":strCheckSum,
                       @"CALLBACK_URL":[dictInfo valueForKey:@"CALLBACK_URL"]
                       };
    
    NSLog(@"order.params : %@", order.params);
    
    PGTransactionViewController *txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
    txnController.loggingEnabled = YES;
    
//    if (type != eServerTypeNone)
//        txnController.serverType = type;
//    else
//        return;
    txnController.merchant = [PGMerchantConfiguration defaultConfiguration];
    txnController.delegate = self;
    
   // [self.window.rootViewController.navigationController pushViewController:txnController animated:true];
    
    [self.window.rootViewController presentViewController:txnController animated:YES completion:NULL];
    
    //[self.window.rootViewController.navigationController pushViewController:txnController animated:YES];

    //[self.navigationController pushViewController:txnController animated:YES];
}


//this function triggers when transaction gets finished
-(void)didFinishedResponse:(PGTransactionViewController *)controller response:(NSString *)responseString {
    
    NSLog(@"Response: %@", responseString);

    [controller dismissViewControllerAnimated:true completion:nil];
    
    //[controller.navigationController popViewControllerAnimated:YES];
}
//this function triggers when transaction gets cancelled
-(void)didCancelTrasaction:(PGTransactionViewController *)controller {
   // [_statusTimer invalidate];
    NSString *msg = [NSString stringWithFormat:@"UnSuccessful"];
    
    [[[UIAlertView alloc] initWithTitle:@"Transaction Cancel" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    [controller dismissViewControllerAnimated:true completion:nil];
    
    //[controller.navigationController popViewControllerAnimated:YES];
}
//Called when a required parameter is missing.
-(void)errorMisssingParameter:(PGTransactionViewController *)controller error:(NSError *) error {
    //[controller.navigationController popViewControllerAnimated:YES];
    
    [controller dismissViewControllerAnimated:true completion:nil];
}



@end
