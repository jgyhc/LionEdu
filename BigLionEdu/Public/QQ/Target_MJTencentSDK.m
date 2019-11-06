//
//  Target_MJTencentSDK.m
//  MJTencentSDK
//
//  Created by -- on 2019/3/15.
//

#import "Target_MJTencentSDK.h"
#import "MJTencentSDK.h"


typedef void (^loginResultBlock)(NSDictionary * info);
@implementation Target_MJTencentSDK

- (id)Action_QQInit:(NSDictionary *)params {
    NSString *appId = [params objectForKey:@"appId"];
    [[MJTencentSDK shareInstance] initSDKWithAppId:appId];
    return nil;
}


- (id)Action_QQLogin:(NSDictionary *)params {
    loginResultBlock block = [params objectForKey:@"completion"];
    [[MJTencentSDK shareInstance] sendQQLoginRequestWithResultBlock:^(APIResponse * _Nonnull response, NSDictionary * _Nonnull userInfo) {
        if (block) {
            block(userInfo);
        }
    }];
    return nil;
}

- (id)Action_iphoneQQInstalled:(NSDictionary *)params {
    return @([[MJTencentSDK shareInstance] iphoneQQInstalled]);
}

- (id)Action_iphoneTIMInstalled:(NSDictionary *)params {
    return @([[MJTencentSDK shareInstance] iphoneTIMInstalled]);
}


@end
