//
//  UIViewController+MJTheme.m
//  ManJi
//
//  Created by manjiwang on 2019/1/7.
//  Copyright © 2019 Zgmanhui. All rights reserved.
//

#import "UIViewController+MJTheme.h"
#import <Aspects/Aspects.h>
#import <objc/runtime.h>

@implementation UIViewController (MJTheme)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *selStringsArray = @[@"viewDidLoad", @"viewWillAppear:", @"viewDidAppear:", @"viewWillDisappear:", @"viewDidDisappear:"];
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            NSString *leeSelString = [@"mj_" stringByAppendingString:selString];
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(leeSelString));
            method_exchangeImplementations(originalMethod, leeMethod);
        }];

    });
}


- (void)mj_viewDidLoad {
    NSLog(@"%@ viewDidLoad", NSStringFromClass([self class]));
    if ([self isBlackViewController]) {
        [self mj_viewDidLoad];
        return;
    }
    self.isFirstIn = YES;
    __weak typeof(self) wself = self;
    [self.navigationController aspect_hookSelector:@selector(setNavigationBarHidden:animated:) withOptions:AspectPositionAfter usingBlock:^{
        if (wself.isFirstIn) {
            wself.navigationBarHidden = wself.navigationController.navigationBarHidden;
        }
    } error:nil];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_black_back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(viewWillBack)];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0], NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W04" size:19]}];    
//    [self wr_setNavBarTintColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
    [self mj_viewDidLoad];
}

- (void)mj_viewWillAppear:(BOOL)animated {
    if ([self isBlackViewController]) {
        [self mj_viewWillAppear:animated];
        return;
    }
    if(self.isFirstIn){
        self.isFirstIn = NO;
        [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    }else{
        [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:YES];
    }

    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self mj_viewWillAppear:animated];
}

- (void)mj_viewDidAppear:(BOOL)animated {
    if ([self isBlackViewController]) {
        [self mj_viewDidAppear:animated];
        return;
    }
    [self mj_viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    //打开侧滑返回
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

- (void)mj_viewWillDisappear:(BOOL)animated {
    if ([self isBlackViewController]) {
        [self mj_viewWillDisappear:animated];
        return;
    }
    [self mj_viewWillDisappear:animated];
    if (self.navigationController.viewControllers.count > 1 && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)mj_viewDidDisappear:(BOOL)animated {
    [self mj_viewWillDisappear:animated];
}


- (void)viewWillBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        // 屏蔽调用rootViewController的滑动返回手势
        if (self.navigationController.viewControllers.count < 2 || self.navigationController.visibleViewController == [self.navigationController.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)isFirstIn {
    return self ? [objc_getAssociatedObject(self, _cmd) boolValue] : NO;
}

- (void)setIsFirstIn:(BOOL)isFirstIn {
    if (self) objc_setAssociatedObject(self, @selector(isFirstIn), @(isFirstIn) , OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)navigationBarHidden {
    return self ? [objc_getAssociatedObject(self, _cmd) boolValue] : NO;
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    if (self) objc_setAssociatedObject(self, @selector(navigationBarHidden), @(navigationBarHidden) , OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isBlackViewController {
    NSArray *list = @[@"UIImagePickerController", @"PUPhotoPickerHostViewController", @"UIAlertControllerTextFieldViewController", @"UIApplicationRotationFollowingController", @"UIAlertController", @"CAMPreviewViewController", @"CAMViewfinderViewController", @"CAMImagePickerCameraViewController", @"MFMessageComposeViewController", @"CKSMSComposeRemoteViewController", @"CKSMSComposeController", @"SSDKRootViewController", @"SSDKNavigationController", @"SSDKAuthViewController", @"SJFullscreenModeNavigationController", @"WBSDKAuthorizeWebViewController", @"PLPhotoTileViewController", @"SJFullscreenModeViewController",@"BLTrainRecordedViewController",@"BLTrainVideoSearchResultController"];
    for (NSString *key in list) {
        if ([self isKindOfClass:NSClassFromString(key)]) {
            return YES;
        }
    }
    return NO;
}

@end
