//
//  UIViewController+BLRotationControl.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/20.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "UIViewController+BLRotationControl.h"
#import "SJVideoPlayer.h"
#import "SJRotationManager.h"



@implementation UIViewController (BLRotationControl)

///
/// 控制器是否可以旋转
///
- (BOOL)shouldAutorotate {
    // 此处为设置 iPhone 哪些控制器可以旋转
    if ( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() ) {
        
        
        // 如果项目仅支持竖屏, 可以直接返回 NO
        //
        // return NO;
        
        
        // 此处为禁止当前Demo中SJ前缀的控制器旋转, 请根据实际项目修改前缀
        NSString *class = NSStringFromClass(self.class);
        if ( [class hasPrefix:@"SJ"] ) {
            // 返回 NO, 不允许控制器旋转
            return NO;
        }
        
        // 返回 YES, 允许控制器旋转
        return YES;
    }
    
    // 此处为设置 iPad 所有控制器都可以旋转
    // - 请根据实际情况进行修改.
    else if ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) {
        return YES;
    }
    return NO;
}

///
/// 控制器旋转支持的方向
///
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 此处为设置 iPhone 某个控制器旋转支持的方向
    // - 请根据实际情况进行修改.
    if ( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() ) {
        // 如果self不支持旋转, 返回仅支持竖屏
        if ( self.shouldAutorotate == NO )
            return UIInterfaceOrientationMaskPortrait;
    }
    
    // 此处为设置 iPad 仅支持横屏
    // - 请根据实际情况进行修改.
    else if ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) {
        return UIInterfaceOrientationMaskLandscape;
    }

    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end

@implementation UITabBarController (RotationControl)
- (UIViewController *)sj_topViewController {
    if ( self.selectedIndex == NSNotFound )
        return self.viewControllers.firstObject;
    return self.selectedViewController;
}

- (BOOL)shouldAutorotate {
    return [[self sj_topViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self sj_topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self sj_topViewController] preferredInterfaceOrientationForPresentation];
}
@end

@implementation UINavigationController (RotationControl)
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
@end
