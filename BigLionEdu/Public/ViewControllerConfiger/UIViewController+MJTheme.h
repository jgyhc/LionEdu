//
//  UIViewController+MJTheme.h
//  ManJi
//
//  Created by manjiwang on 2019/1/7.
//  Copyright © 2019 Zgmanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MJTheme)<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isFirstIn;

@property (nonatomic, assign) BOOL navigationBarHidden;
@end

NS_ASSUME_NONNULL_END
