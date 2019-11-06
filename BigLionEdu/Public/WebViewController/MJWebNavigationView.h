//
//  MJWebNavigationView.h
//  MJWebViewKit_Example
//
//  Created by -- on 2019/2/18.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, MJWebNavigationViewType) {
    MJWebNavigationViewTypeNormal,//有正常的导航栏
    
    MJWebNavigationViewTypeOnlyStatusBar,//只有一个状态栏
    
    MJWebNavigationViewTypeNoNavigationView//没有导航栏
};


@interface MJWebNavigationView : UIView

@property (nonatomic, assign) MJWebNavigationViewType type;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, strong) UIButton * rightButton;

@property (nonatomic, strong) UIButton * closeButton;

- (void)addRightButtonWithTitle:(NSString *)title target:(nullable id)target action:(SEL)action;

- (void)addRightButtonWithImageUrl:(NSString *)imageUrl target:(nullable id)target action:(SEL)action;

- (void)addRightButtonWithImageName:(NSString *)imageName target:(nullable id)target action:(SEL)action;

- (void)addBackAndCloseButtonWithTarget:(nullable id)target backAction:(SEL)backAction closeAction:(SEL)closeAction;


@end

NS_ASSUME_NONNULL_END
