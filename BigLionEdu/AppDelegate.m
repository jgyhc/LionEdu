//
//  AppDelegate.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "AppDelegate.h"
#import "UIViewController+MJTheme.h"
#import <CTMediator.h>
#import "MJWeChatSDK.h"
#import "BLAreaManager.h"
#import "MJSystemLocationManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayManager.h"
#import "FKDownloader.h"
#import <SJVideoPlayer.h>
#import "UIViewController+BLRotationControl.h"
#import <SDWebImage.h>
#import "ZLUserInstance.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    self.window.rootViewController = [mainStoryboard instantiateInitialViewController];
//    [self.window makeKeyAndVisible];
    [[CTMediator sharedInstance] performTarget:@"MJWeChatSDK" action:@"WeChatInit" params:@{@"appId": @"wx8a0ede166cd8eed2",
                                                                                            @"appSecret":@"4ed330f75f7fb2b56273da5494dbfbe5"
                                                                                            } shouldCacheTarget:NO];
    
    
    [[BLAreaManager sharedInstance] startRequestArea];
    
    [FKDownloadManager manager].configure.maximumExecutionTask = 1;
    [FKDownloadManager manager].configure.allowCellular = YES;
    [FKDownloadManager manager].configure.deleteFinishFile = YES;
    [FKDownloadManager manager].configure.calculateSpeedWithEstimated = YES;
    
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader setValue:[ZLUserInstance sharedInstance].token forHTTPHeaderField:@"user"];
    
    SJVideoPlayer.update(^(SJVideoPlayerSettings * _Nonnull common) {
//        common.placeholder = [UIImage imageNamed:@"placeholder"];
        common.progress_thumbSize = 8;
        common.progress_trackColor = [UIColor colorWithWhite:0.8 alpha:1];
        common.progress_bufferColor = [UIColor whiteColor];
    });
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAll;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[MJSystemLocationManager sharedLocation] stopLocation];;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[MJSystemLocationManager sharedLocation] stopLocation];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [MJSystemLocationManager startGetLocation:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    [[MJWeChatSDK shareInstance] handleOpenURL:url];
    if ([url.host isEqualToString:@"safepay"]) {
#pragma mark - ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~支付宝回调
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([AlipayManager sharedManager].AlipayManagerBlock) {
                [AlipayManager sharedManager].AlipayManagerBlock(resultDic);
            }
        }];
    }
    return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    
    if ([identifier isEqualToString:[FKDownloadManager manager].configure.sessionIdentifier]) {
        // !!!: 用户可在此处自定义配置配置实例, 以避免部分参数与 kill app 时的配置不符
        [FKDownloadManager manager].configure.maximumExecutionTask = 1;
        [FKDownloadManager manager].configure.allowCellular = YES;
        [FKDownloadManager manager].configure.deleteFinishFile = YES;
        [FKDownloadManager manager].configure.calculateSpeedWithEstimated = YES;
        [FKDownloadManager manager].configure.backgroundHandler = completionHandler;
    }
}


@end
