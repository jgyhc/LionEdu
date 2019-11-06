//
//  Target_MJWeChatSDK.m
//  MJWechatSDK
//
//  Created by -- on 2019/3/15.
//

#import "Target_MJWeChatSDK.h"
#import "MJWeChatSDK.h"
#import <UIKit/UIKit.h>

typedef void (^loginResultBlock)(NSDictionary * info);
@implementation Target_MJWeChatSDK

- (id)Action_WeChatInit:(NSDictionary *)params {
    NSString *appId = [params objectForKey:@"appId"];
    NSString *appSecret = [params objectForKey:@"appSecret"];
    [[MJWeChatSDK shareInstance] initSDKWithAppId:appId appSecret:appSecret];
    return nil;
}

- (id)Action_WeChatLogin:(NSDictionary *)params {
    UIViewController *viewController = [params objectForKey:@"viewController"];
    loginResultBlock block = [params objectForKey:@"completion"];
    [[MJWeChatSDK shareInstance] sendWeixinLoginRequestWithViewController:viewController resultBlock:^(NSDictionary * _Nonnull userInfo) {
        if (block) {
            block(userInfo);
        }
    } codeResultBlock:nil];

    return nil;
}

@end
