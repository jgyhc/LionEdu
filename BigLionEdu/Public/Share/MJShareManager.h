//
//  ShareManager.h
//  ManJi
//
//  Created by Zgmanhui on 16/8/6.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJShareUIView.h"


@interface MJShareManager : NSObject

+ (instancetype)sharedManager;

/** 调用前  请确认已经注册了三方应用 */
- (void)showShareViewWithParams:(NSDictionary *)params;

- (void)shareWithParams:(NSDictionary *)params;

- (void)showShareView;

- (void)hideShareView;

- (void)setShareParams:(NSDictionary *)params;
#pragma mark -- 通用的分享
- (void)generalShareWithType:(ShareUIViewType)type;

/**
 系统的分享功能

 @param viewController 试图控制器
 @param title 标题
 @param image 图片
 @param url 链接
 */
- (void)systemShareManagerWithViewController:(UIViewController *)viewController title:(NSString *)title image:(UIImage *)image url:(NSURL *)url;

- (id)Action_systemShare:(NSDictionary *)params;
@end
