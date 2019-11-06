//
//  Target_web.m
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/14.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "Target_web.h"
#import "MJWebViewController.h"
#import <CTMediator.h>
#import <Photos/Photos.h>
#import "LCProgressHUD.h"
#import "MJWeChatSDK.h"
//#import "ZLEarningReportDetailTableViewController.h"
//#import "UIViewController+ORAdd.h"

@implementation Target_web

- (id)Action_webViewController:(NSDictionary *)params {
    MJWebViewController *viewController = [[MJWebViewController alloc] init];
    NSString *urlString = [params objectForKey:@"url"];
    NSString *htmlString = [params objectForKey:@"htmlString"];
    NSString *title = [params objectForKey:@"title"];
    if (title) {
        viewController.titleString = title;
    }
    if (htmlString) {
        viewController.htmlString = htmlString;
    }
    if (urlString) {
        viewController.url = [NSURL URLWithString:urlString];
    }
    NSDictionary *shareInfo = [params objectForKey:@"shareInfo"];
    if (shareInfo) {
        viewController.shareInfo = shareInfo;
    }
    viewController.navigationType = 0;
    return viewController;
}

- (id)Action_share:(NSDictionary *)params {
    /** {
     content = "\U6211\U662f\U5206\U4eab\U7684\U5185\U5bb9\Uff0c\U6d4b\U8bd5";
     icon = "http://www.zhenxc.com/favicon.ico";
     title = "\U6211\U662f\U5206\U4eab\U7684\U6807\U9898\Uff0c\U6d4b\U8bd5";
     url = "http://www.zhenxc.com/app/pages/headline.html?uuid=5359e977dd4c433e8b6d8964ebce808b&from=ZGlAL5icjkIKKq3LqUw7GQ==";
     }; */
    NSString *content = [params objectForKey:@"content"];
    NSString *url = [params objectForKey:@"url"];
    NSString *icon = [params objectForKey:@"icon"];
    NSString *title = [params objectForKey:@"title"];
    [[CTMediator sharedInstance] performTarget:@"share"
                                        action:@"mjshare"
                                        params:@{
                                                 @"sid":@"",
                                                 @"shareEventCallbackUrl":@"",
                                                 @"generalOptions": @{
                                                         @"describe": content?content:@"",
                                                         @"img": icon?icon:@"",
                                                         @"linkurl": url?url:@"",
                                                         @"title": title?title:@""
                                                         }
                                                 } shouldCacheTarget:YES];
    return nil;
}

- (id)Action_posterShare:(NSDictionary *)params {
    NSString *base64String = [params objectForKey:@"image"];
    NSString *string = [[base64String componentsSeparatedByString:@","] lastObject];
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:string options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    
    UIImage *image = [UIImage imageWithData: decodeData];
    if (image) {
        [[CTMediator sharedInstance] performTarget:@"share" action:@"mjshare" params:@{
                                                                                       @"sid":@"",
                                                                                       @"shareEventCallbackUrl":@"",
                                                                                       @"generalOptions": @{
                                                                                               @"images": @[decodeData],
                                                                                               }
                                                                                       } shouldCacheTarget:YES];
    }

    return nil;
}

- (id)Action_posterSave:(NSDictionary *)params {
    NSString *base64String = [params objectForKey:@"image"];
    NSString *string = [[base64String componentsSeparatedByString:@","] lastObject];
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:string options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    
    UIImage *image = [UIImage imageWithData: decodeData];
    NSError * error = nil;
    __block NSString * assetID =  nil;
    [[PHPhotoLibrary sharedPhotoLibrary]  performChangesAndWait:^{
        assetID =  [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        
    } error:&error];
    if (!error) {
        [LCProgressHUD show:@"保存成功"];
    }else {
        [LCProgressHUD show:@"保存失败了"];
    }
    return nil;
}

- (id)Action_openSmallProgram:(NSDictionary *)params {
    NSString *userName = [params objectForKey:@"userName"];
    NSString *path = [params objectForKey:@"path"];
    [[MJWeChatSDK shareInstance] openMiniProgramWithUserName:userName path:path];
    return nil;
}

- (id)Action_appPage:(NSDictionary *)params {
//    ZLEarningReportDetailTableViewController *vc = [[UIStoryboard storyboardWithName:@"UserCenter" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ZLEarningReportDetailTableViewController"];
//    vc.subject = [[params objectForKey:@"subject"] integerValue];
//    [[UIViewController currentViewController].navigationController pushViewController:vc animated:YES];
    return nil;
}

@end
