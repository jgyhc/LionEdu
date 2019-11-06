//
//  MJWeChatSDK.h
//  MJWechatSDK_Example
//
//  Created by -- on 2019/2/14.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MJWeChatSDKShareType) {
    MJWeChatSDKImageType    = 0,//图片
    MJWeChatSDKMusicType   = 1,//音乐
    MJWeChatSDKVideoType = 2,//视频
    MJWeChatSDKWebpageType ,//链接
};

typedef NS_ENUM(NSInteger, MJWeChatSDKShareWay) {
    MJWeChatSDKShareWeixinFriendWay    = 0,//微信好友
    MJWeChatSDKShareTimelineWay   = 1,//朋友圈
    MJWeChatSDKShareCollectWay // 收藏 待开发
};


@interface MJWeChatSDK : NSObject

/**
 实例化
 */
+ (instancetype)shareInstance;

/**
 初始化微信SDK
 */
- (void)initSDKWithAppId:(NSString *)appId appSecret:(NSString *)appSecret;

/**
 打开其他app的回调
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 调用微信登录接口
 */
- (void)sendWeixinLoginRequestWithViewController:(UIViewController *)viewController resultBlock:(nullable void(^)(NSDictionary *userInfo))resultBlock codeResultBlock:(void(^)(NSString *code))codeResultBlock;


/**
 查看微信是否安装
 */
- (BOOL)isWeiXinInstall;



/**
 打开微信小程序

 @param userName 小程序的username
 @param path 拉起小程序页面的可带参路径，不填默认拉起小程序首页
 */
- (void)openMiniProgramWithUserName:(NSString *)userName path:(NSString *)path;
/**
 微信支付
 @param openID     微信开放平台审核通过的应用APPID
 @param partnerId     微信支付分配的商户号
 @param prepayId     微信返回的支付交易会话ID
 @param nonceStr     随机字符串，不长于32位。推荐随机数生成算法
 @param timeStamp 时间戳，请见接口规则-参数规定
 @param package  暂填写固定值Sign=WXPay
 @param sign 签名，详见签名生成算法注意：签名方式一定要与统一下单接口使用的一致
 @param resultBlock 回调
 */
- (void)payForWechat:(NSString *)openID partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp package:(NSString *)package sign:(NSString *)sign viewController:(UIViewController *)viewController resultBlock:(void(^)(NSNumber *errCode))resultBlock;



/**
 分享

 @param params 类型
 @param shareType 分享类型
 @param way 分享途径
 */
- (void)shareWithParams:(NSDictionary *)params shareType:(MJWeChatSDKShareType)shareType way:(MJWeChatSDKShareWay)way;

@end

NS_ASSUME_NONNULL_END
