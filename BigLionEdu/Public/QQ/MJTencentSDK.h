//
//  MJTencentSDK.h
//  MJQQAbility_Example
//
//  Created by -- on 2019/1/31.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJTencentSDK : NSObject

/**
 实例化
 */
+ (instancetype)shareInstance;

/**
 初始化
 */
- (void)initSDKWithAppId:(NSString *)appId;

/**
 请求调用qq登录
 */
- (void)sendQQLoginRequestWithResultBlock:(void(^)(APIResponse * response, NSDictionary *userInfo))resultBlock;

/** 是否安装QQ */
- (BOOL)iphoneQQInstalled;

/** 是否安装TIM */
- (BOOL)iphoneTIMInstalled;

/**
 openURL
 */
+ (BOOL)handleOpenURL:(NSURL *)url;



/**
 分享到QQ

 @param url url
 @param title title
 @param content l内容
 @param image 图片
 @return 结果
 */
+ (QQApiSendResultCode)shareToQQWithUrl:(NSURL *)url title:(NSString *)title content:(NSString *)content image:(id)image;

/**
 分享到QQ空间
 
 @param url url
 @param title title
 @param content l内容
 @param image 图片
 @return 结果
 */
+ (QQApiSendResultCode)shareToQZoneWithUrl:(NSURL *)url title:(NSString *)title content:(NSString *)content image:(id)image;



@end

NS_ASSUME_NONNULL_END
