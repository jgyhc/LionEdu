//
//  UIViewController+ZLCustomNavigationBar.m
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "UIViewController+ZLCustomNavigationBar.h"
#import <objc/runtime.h>
#import <Aspects/Aspects.h>
#import <Masonry.h>
#import "AdaptScreenHelp.h"

static NSString *customNavigationBarKey = @"customNavigationBarKey";
@implementation UIViewController (ZLCustomNavigationBar)


- (void)setCustomNavigationBar:(ZLCustomNavigationBar *)customNavigationBar {
    if (customNavigationBar != self.customNavigationBar) {
        objc_setAssociatedObject(self, &customNavigationBarKey, customNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        UIView *view = self.view;
        
        if ([self isKindOfClass:[UITableViewController class]] || [self isKindOfClass:[UICollectionViewController class]]) {
            view = [[UIApplication sharedApplication] keyWindow];
            __block UIView * blockView = view;
            __weak __typeof(self)wself = self;
            [self aspect_hookSelector:@selector(viewDidDisappear:) withOptions:AspectPositionAfter usingBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.3 animations:^{
                        wself.customNavigationBar.alpha = 0;
                    } completion:^(BOOL finished) {
                        [customNavigationBar removeFromSuperview];
                    }];
                });
            } error:nil];
            
            [self aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    wself.customNavigationBar.alpha = 1;
                    [blockView addSubview:wself.customNavigationBar];
                    [wself.customNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.right.mas_equalTo(blockView);
                        make.height.mas_equalTo(NavigationHeight());
                    }];
                });
            } error:nil];
        }
        [view addSubview:self.customNavigationBar];
        [self.customNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(view);
            make.height.mas_equalTo(NavigationHeight());
        }];
        __weak typeof(self) wself = self;
        [customNavigationBar setLeftClickEventBlock:^(id  _Nonnull sender) {
            [wself.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (ZLCustomNavigationBar *)customNavigationBar {
    return objc_getAssociatedObject(self, &customNavigationBarKey);
}

@end
