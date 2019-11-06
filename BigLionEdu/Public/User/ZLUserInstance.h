//
//  ZLUserInstance.h
//  ManJi
//
//  Created by manjiwang on 2018/12/18.
//  Copyright © 2018 Zgmanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ZLUserLoginNotificationKey;
extern NSString * const ZLUserLoginOutNotificationKey;

extern NSString * const ZLUserInfoUpdateNotificationKey;

@interface ZLUserInstance : NSObject
+ (instancetype)sharedInstance;

- (void)loginWithToken:(NSString *)token;

- (void)loginWithUserInfo:(NSDictionary *)userInfo;
- (void)loginOutWithViewController:(UIViewController *)viewController;

- (void)separateUpdateUserInfo:(NSDictionary *)userInfo;

- (void)removeUserInfo;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *icon;
/** 当前是否登录 */
@property (nonatomic, assign, readonly) BOOL isLogin;

@property (nonatomic, copy, readonly) NSString *token;

@property (nonatomic, copy, readonly) NSString *nickname;

@property (nonatomic, copy, readonly) NSString *userids;

@property (nonatomic, copy, readonly) NSString *photo;

@property (nonatomic, copy, readonly) NSString *phone;

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, assign) BOOL isCheckIn;//是否已经签到

@property (nonatomic, strong) NSArray *levelList;


@end

NS_ASSUME_NONNULL_END
