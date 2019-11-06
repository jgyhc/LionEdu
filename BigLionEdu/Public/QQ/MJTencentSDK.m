//
//  MJTencentSDK.m
//  MJQQAbility_Example
//
//  Created by -- on 2019/1/31.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import "MJTencentSDK.h"


@interface MJTencentSDK ()<TencentSessionDelegate>
@property (strong, nonatomic)TencentOAuth *tencentOAuth;

@property (nonatomic, copy) void (^QQLoginBlock)(APIResponse * response, NSDictionary *userInfo);

@end

@implementation MJTencentSDK



static NSURL *safeURL(NSString * origin) {
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [origin stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    return [NSURL URLWithString:encodeUrl];
}

//单例模式供外调用基类对象
+ (instancetype)shareInstance {
    static MJTencentSDK *tenctentSDK;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tenctentSDK = [[MJTencentSDK allocWithZone:nil] init];
    });
    return tenctentSDK;
}

- (BOOL)iphoneQQInstalled {
    return [TencentOAuth iphoneQQInstalled];
}

- (BOOL)iphoneTIMInstalled {
    return [TencentOAuth iphoneTIMInstalled];
}

#pragma mark - qq登录
- (void)sendQQLoginRequestWithResultBlock:(void(^)(APIResponse * response, NSDictionary *userInfo))resultBlock {
    _QQLoginBlock = resultBlock;
    NSArray* permissions = [NSArray arrayWithObjects: kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    BOOL isSuccess = [_tencentOAuth authorize:permissions inSafari:NO];
    if (isSuccess) {
        NSLog(@"QQ调用登录成功");
    }else{
        NSLog(@"QQ调用登录失败");
    }
}

//登录成功后的回调
- (void)tencentDidLogin {
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]) {
        BOOL isGetUserInfo = [_tencentOAuth getUserInfo];
        if (isGetUserInfo) {
            NSLog(@"获取用户QQ信息成功");
        }
    }else{
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}

//获取用户信息回调
- (void)getUserInfoResponse:(APIResponse*) response {
    if (response.jsonResponse == nil) {
        return;
    }
    if (_QQLoginBlock) {
        NSDictionary *jsonResponse = response.jsonResponse;
        NSString *gender = jsonResponse[@"gender"];
        NSString *accessToken = _tencentOAuth.accessToken;
        NSString *nickname = jsonResponse[@"nickname"];
        NSString *icon = jsonResponse[@"figureurl_qq_2"];
        NSString *openid = _tencentOAuth.openId;
        NSDictionary *dict = @{
                               @"oauthName": @"qq",
                               @"openid": openid?openid:@"",
                               @"unionid": @"",
                               @"icon": icon?icon:@"",
                               @"nickname":nickname?nickname:@"",
                               @"accessToken":accessToken?accessToken:@"",
                               @"sex": gender?gender:@""
                               };
        _QQLoginBlock(response, dict);
    }
    //获取到用户信息后根据需要保存在本地或上传到服务端,用作的用户信息
}

//登录失败后的回调(cancelled 代表用户是否主动退出登录)
- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

//登录时网络有问题的回调
- (void)tencentDidNotNetWork {
    
}

//初始化
- (void)initSDKWithAppId:(NSString *)appId {
    //appID:从腾讯那里申请的你的应用的AppID
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:self];
}

//openURL
+ (BOOL)handleOpenURL:(NSURL *)url {
    return [TencentOAuth HandleOpenURL:url];
}

//分享到QQ好友
+ (QQApiSendResultCode)shareToQQWithUrl:(NSURL *)url title:(NSString *)title content:(NSString *)content image:(id)image {
    return [self shareWithUrl:url title:title content:content image:image type:0];
}

//分享到QQ空间
+ (QQApiSendResultCode)shareToQZoneWithUrl:(NSURL *)url title:(NSString *)title content:(NSString *)content image:(id)image {
    return [self shareWithUrl:url title:title content:content image:image type:1];
}

+ (QQApiSendResultCode)shareWithUrl:(NSURL *)url title:(NSString *)title content:(NSString *)content image:(id)image type:(NSInteger)type {
    QQApiURLObject *object;
    NSData *imageData;
    NSURL *imageUrl;
    if ([image isKindOfClass:[UIImage class]]) {
        imageData = UIImagePNGRepresentation(image);
    }else if ([image isKindOfClass:[NSData class]]) {
        imageData = image;
    }else if ([image isKindOfClass:[NSString class]]) {
        imageUrl = safeURL(image);
    }else if ([image isKindOfClass:[NSURL class]]) {
        imageUrl = imageUrl;
    }
    if (imageUrl) {
        object = [[QQApiURLObject alloc] initWithURL:url title:title description:content previewImageURL:imageUrl targetContentType:QQApiURLTargetTypeNews];
    }else if (imageData) {
        object = [[QQApiURLObject alloc] initWithURL:url title:title description:content previewImageData:imageData targetContentType:QQApiURLTargetTypeNews];
    }
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
    
    if (type == 0) {
        return [QQApiInterface sendReq:req];
    }
    return [QQApiInterface SendReqToQZone:req];
}



@end
