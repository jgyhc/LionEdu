//
//  MJWeChatSDK.m
//  MJWechatSDK_Example
//
//  Created by -- on 2019/2/14.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import "MJWeChatSDK.h"
#import <WXApi.h>

#define Weixin_GetAccessTokenURL    @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"
#define Weixin_isAccessTokenCanUse     @"https://api.weixin.qq.com/sns/auth?access_token=%@&openid=%@"
#define Weixin_UseRefreshToken      @"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@"
#define Weixin_GetUserInformation  @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@"

@interface MJWeChatSDK ()<WXApiDelegate>

@property (nonatomic, copy) NSString * appSecret;

@property (nonatomic, copy) NSString * appID;

@property (nonatomic, copy) void (^WeChatLoginBlock)(NSDictionary *userInfo);

@property (nonatomic, strong) NSMutableDictionary * userInfo;

@property (nonatomic, copy) void (^WeChatPayResultBlock)(NSNumber *errCode);

@property (nonatomic, copy) void (^WeChatLoginCodeBlock)(NSString *code);

@end

@implementation MJWeChatSDK

static NSURL *safeURL(NSString * origin) {
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [origin stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    return [NSURL URLWithString:encodeUrl];
}

/**
 实例化
 */
+ (instancetype)shareInstance {
    static MJWeChatSDK *weChatSDK;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weChatSDK = [[MJWeChatSDK allocWithZone:nil] init];
    });
    return weChatSDK;
}

/**
 初始化微信SDK
 */
- (void)initSDKWithAppId:(NSString *)appId appSecret:(NSString *)appSecret {
    _appSecret = appSecret;
    _appID = appId;
    [WXApi registerApp:appId];
}

/**
 打开其他app的回调
 */
- (BOOL)handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

/**
 调用微信登录接口
 */
- (void)sendWeixinLoginRequestWithViewController:(UIViewController *)viewController resultBlock:(nullable void(^)(NSDictionary *userInfo))resultBlock codeResultBlock:(void(^)(NSString *code))codeResultBlock{
    _WeChatLoginBlock = resultBlock;
    _WeChatLoginCodeBlock = codeResultBlock;
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"";
    if ([self isWeiXinInstall]) {
        [WXApi sendReq:req];
    }else {
        [WXApi sendAuthReq:req viewController:viewController delegate:self];
    }
}

#pragma mark -- WXApiDelegate method
- (void)onReq:(BaseReq*)req {
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp 具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp *)resp {
    /** 微信登录 */
    if([resp isKindOfClass:[SendAuthResp class]]){
        if (resp.errCode == 0) {
            [self loginWeixinSuccessWithBaseResp:resp];
        }else{
            //登录失败
        }
    }
    /** 微信支付 */
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        if (self.WeChatPayResultBlock) {
            self.WeChatPayResultBlock(@(response.errCode));
        }
    }
}

#pragma mark - 微信登录成功获取token
- (void)loginWeixinSuccessWithBaseResp:(BaseResp *)resp {
    SendAuthResp  *auth = (SendAuthResp*)resp;
    NSString *code = auth.code;
    if (_WeChatLoginCodeBlock) {
        _WeChatLoginCodeBlock(code);
    }
    if (_WeChatLoginBlock) {
        //Weixin_AppID和Weixin_AppSecret是微信申请下发的.
        [self.userInfo setObject:@"weixin" forKey:@"oauthName"];
        NSString *str = [NSString stringWithFormat:Weixin_GetAccessTokenURL, _appID, _appSecret, code];
        [self getRequestWithUrl:[NSURL URLWithString:str] success:^(NSDictionary *responseDict) {
            NSString *access_token = responseDict[@"access_token"];
            NSString *refresh_token = responseDict[@"refresh_token"];
            NSString *openid = responseDict[@"openid"];
            [self isAccessTokenCanUseWithAccessToken:access_token openID:openid completionHandler:^(BOOL isCanUse) {
                if (isCanUse) {
                    [self getUserInformationWithAccessToken:access_token openID:openid];
                }else{
                    [self useRefreshToken:refresh_token];
                }
            }];
        } failure:^(NSError *error) {
            NSLog(@"请求失败--%@",error);
        }];
    }
}

#pragma mark - 若过期,使用refresh_token获取新的access_token
- (void)useRefreshToken:(NSString *)refreshToken {
    NSString *strOfUseRefreshToken = [NSString stringWithFormat:Weixin_UseRefreshToken, _appID, refreshToken];
    __weak typeof(self) wself = self;
    [self getRequestWithUrl:[NSURL URLWithString:strOfUseRefreshToken] success:^(NSDictionary *responseDict) {
        NSString *openid = responseDict[@"openid"];
        NSString *access_token = responseDict[@"access_token"];
        NSString *refresh_tokenNew = responseDict[@"refresh_token"];
        [wself isAccessTokenCanUseWithAccessToken:access_token openID:openid completionHandler:^(BOOL isCanUse) {
            if (isCanUse) {
                [wself getUserInformationWithAccessToken:access_token openID:openid];
            }else{
                [wself useRefreshToken:refresh_tokenNew];
            }
        }];
    } failure:^(NSError *error) {
        NSLog(@"请求失败--%@",error);
    }];
}

#pragma mark - 判断access_token是否过期
- (void)isAccessTokenCanUseWithAccessToken:(NSString *)accessToken openID:(NSString *)openID completionHandler:(void(^)(BOOL isCanUse))completeHandler {
    NSString *strOfSeeAccess_tokenCanUse = [NSString stringWithFormat:Weixin_isAccessTokenCanUse, accessToken, openID];
    [self getRequestWithUrl:[NSURL URLWithString:strOfSeeAccess_tokenCanUse] success:^(NSDictionary *responseDict) {
        if ([responseDict[@"errmsg"] isEqualToString:@"ok"]) {
            completeHandler(YES);
        }else{
            completeHandler(NO);
        }
    } failure:^(NSError *error) {
        NSLog(@"请求失败--%@",error);
        completeHandler(NO);
    }];
}

#pragma mark - 若未过期,获取用户信息
- (void)getUserInformationWithAccessToken:(NSString *)access_token openID:(NSString *)openID {
    if (access_token) {
        [self.userInfo setObject:access_token forKey:@"accessToken"];
    }
    if (openID) {
        [self.userInfo setObject:openID forKey:@"openid"];
    }
    __weak typeof(self) wself = self;
    NSString *strOfGetUserInformation = [NSString stringWithFormat:Weixin_GetUserInformation, access_token, openID];
    [self getRequestWithUrl:[NSURL URLWithString:strOfGetUserInformation] success:^(NSDictionary *responseDict) {
        NSString *nickname = responseDict[@"nickname"];
        NSString *headimgurl = responseDict[@"headimgurl"];
        NSNumber *sexnumber = responseDict[@"sex"];
        NSString *sexstr = [NSString stringWithFormat:@"%@",sexnumber];
        NSString *sex;
        if ([sexstr isEqualToString:@"1"]) {
            sex = @"男";
        }else if ([sexstr isEqualToString:@"2"]){
            sex = @"女";
        }else{
            sex = @"未知";
        }
        [wself.userInfo setObject:sex forKey:@"sex"];
        if (nickname) {
            [wself.userInfo setObject:nickname forKey:@"nickname"];
        }
        if (headimgurl) {
            [wself.userInfo setObject:headimgurl forKey:@"icon"];
        }
        if (wself.WeChatLoginBlock) {
            wself.WeChatLoginBlock(wself.userInfo);
        }
    } failure:^(NSError *error) {
        NSLog(@"请求失败--%@",error);
    }];
}

/**
 查看微信是否安装
 */
- (BOOL)isWeiXinInstall {
    return [WXApi isWXAppInstalled] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Whatapp://"]];
}


- (void)shareWithParams:(NSDictionary *)params shareType:(MJWeChatSDKShareType)shareType way:(MJWeChatSDKShareWay)way {
    WXMediaMessage *message = [WXMediaMessage message];
    id object;
    switch (shareType) {
        case MJWeChatSDKImageType: {
            WXImageObject *imageObject = [WXImageObject object];
            id image = [params objectForKey:@"image"];
            NSData *imageData;
            if ([image isKindOfClass:[NSData class]]) {
                [message setThumbImage:[self compressImage:[UIImage imageWithData:image] toByte:32765]];
                imageData = image;
            }else if ([image isKindOfClass:[UIImage class]]) {
                [message setThumbImage:[self compressImage:image toByte:32765]];
                imageData = UIImageJPEGRepresentation(image, 1.0f);
            }else if ([image isKindOfClass:[NSString class]]) {
                dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
                dispatch_async(globalQueue,^{
                    NSData *data = [NSData dataWithContentsOfURL:image];
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [message setThumbImage:[self compressImage:rImage toByte:32765]];
                        imageObject.imageData = data;
                        message.mediaObject = object;
                        [self sendReqWithMessage:message scene:way];
                    });
                });
                return;
            }
            imageObject.imageData = imageData;
            object = imageObject;
        }
            break;
        case MJWeChatSDKMusicType: {
            
        }
            break;
        case MJWeChatSDKVideoType: {
            
        }
            break;
        case MJWeChatSDKWebpageType: {
            NSString *url = [params objectForKey:@"url"];
            WXWebpageObject *webpageObject = [WXWebpageObject object];
            webpageObject.webpageUrl = url;
            NSString *title = [params objectForKey:@"title"];
            NSString *content = [params objectForKey:@"content"];
            message.title = title;
            message.description = content;
            id image = [params objectForKey:@"image"];
            object = webpageObject;
            UIImage *imageObject;
            NSURL *imageUrl;
            
            if ([image isKindOfClass:[UIImage class]]) {
                imageObject = image;
            }else if ([image isKindOfClass:[NSData class]]) {
                imageObject = [UIImage imageWithData:image];
            }else if ([image isKindOfClass:[NSString class]]) {
                imageUrl = safeURL(image);
            }else if ([image isKindOfClass:[NSURL class]]) {
                imageUrl = image;
            }
            if (imageObject) {
                [message setThumbImage:imageObject];
            }
            if (imageUrl && imageUrl.path.length > 0) {
                dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
                dispatch_async(globalQueue,^{
                    NSData *data = [NSData dataWithContentsOfURL:imageUrl];
                    UIImage *image = [UIImage imageWithData:data];
                    if(image != nil){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [message setThumbImage:[self compressImage:image toByte:32765]];
                            message.mediaObject = object;
                            [self sendReqWithMessage:message scene:way];
                        });
                    }
                    else{
                        NSLog(@"图片下载出现错误");
                    }
                });
                return;
            }
        }
            break;
            
        default:
            break;
    }
    message.mediaObject = object;
    [self sendReqWithMessage:message scene:way];
}


- (void)sendReqWithMessage:(WXMediaMessage *)message scene:(int)scene {

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

/**
 获取appstore上app的信息
 @param success success description
 @param failure failure description
 */
- (void)getRequestWithUrl:(NSURL *)url success:(void (^)(NSDictionary * responseDict))success failure:(void (^)(NSError *error))failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error) {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                if(success) success(responseDict);
            }
            else {
                if(failure) failure(error);
            }
        });
    }];
    [dataTask resume];
}


- (void)payForWechat:(NSString *)openID partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp package:(NSString *)package sign:(NSString *)sign viewController:(UIViewController *)viewController resultBlock:(void(^)(NSNumber *errCode))resultBlock {
    _WeChatPayResultBlock = resultBlock;
    PayReq *req = [[PayReq alloc] init];
    req.openID = openID;
    req.partnerId = partnerId;
    req.prepayId = prepayId;
    req.nonceStr = nonceStr;
    req.timeStamp = timeStamp.intValue;
    req.package = package;
    req.sign = sign;
    [WXApi sendReq:req];
//    
//    if ([self isWeiXinInstall]) {
//        PayReq *req = [[PayReq alloc] init];
//        req.openID = openID;
//        req.partnerId = partnerId;
//        req.prepayId = prepayId;
//        req.nonceStr = nonceStr;
//        req.timeStamp = timeStamp.intValue;
//        req.package = package;
//        req.sign = sign;
//        [WXApi sendReq:req];
//    }else {
//        SendAuthReq *req = [[SendAuthReq alloc] init];
//        req.scope = @"snsapi_userinfo";
//        req.state = @"";
//        [WXApi sendAuthReq:req viewController:viewController delegate:self];
//    }
}

#pragma mark - 压缩图片
- (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

- (void)openMiniProgramWithUserName:(NSString *)userName path:(NSString *)path {
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = userName;  //拉起的小程序的username
    launchMiniProgramReq.path = path;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq];
}

- (NSMutableDictionary *)userInfo {
    if (!_userInfo) {
        _userInfo = [NSMutableDictionary dictionary];
    }
    return _userInfo;
}




@end
