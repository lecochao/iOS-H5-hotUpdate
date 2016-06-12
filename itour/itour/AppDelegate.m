//
//  AppDelegate.m
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "AppDelegate.h"
#import "Root.h"
#import "HTML5.h"
#import "AMapLocationKit/AMapLocationKit.h"
#import "iTourNetworking.h"

#import "UMsocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // Override point for customization after application launch.
    [iTourNetworking netWorkingStatus];
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    Root *root = [[Root alloc] init];
    [self.window setRootViewController:root.tabBarController];
    [self.window makeKeyAndVisible];
    [iTourNetworking iTourUserLoading];
    [self HTML5];
    [AMapLocationServices sharedServices].apiKey = @"8841b6319ba51df079a4710133fd42cf";
    
    // 友盟分享
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:@"574812c067e58ea7d700278b"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx850cb27926df7e72" appSecret:@"e49c5596851ed6bfff53223471d5c3e7" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1010805513"
                                              secret:@"d228c15d68bd5bdaa55f763721ed5b27"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
   

    
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options

{
    
    return  [UMSocialSnsService handleOpenURL:url];
    
}

- (BOOL)application:(UIApplication *)application

            openURL:(NSURL *)url

  sourceApplication:(NSString *)sourceApplication

         annotation:(id)annotation

{
    
    return  [UMSocialSnsService handleOpenURL:url];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)HTML5
{
    HTML5 *h5 = [[HTML5 alloc]init];
    NSString *appFirst = ITOUR_GET_OBJECT(APPFirstStarting);
    if (!appFirst) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL scceed = [h5 zipWriteAtDocument];
            if (scceed) {
                BOOL release = [h5 zipReleaseAtHTML5];
                if (release) {
                    
                    NSLog(@"HTML5写入沙盒成功");
                    ITOUR_SET_OBJECT(APPFirstStarting, APPFirstStarting);
                    ITOUR_SET_OBJECT(APPSourceFV, HTML5Versions);//存储 当前 H5 版本
                }else NSLog(@"HTML5写入沙盒失败");
            }else NSLog(@"HTML5.zip写入沙盒失败");
    
            dispatch_async(dispatch_get_main_queue(), ^{

                [[NSNotificationCenter defaultCenter] postNotificationName:@"webViewReload" object:nil];
            });
        });
    }
    [h5 updateZipData];
}
@end
