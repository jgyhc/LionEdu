//
//  UINavigationController+ZLConfiger.m
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/5.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "UINavigationController+ZLConfiger.h"
#import <objc/runtime.h>

@implementation UINavigationController (ZLConfiger)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *selStringsArray = @[@"pushViewController:animated:"];
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            NSString *leeSelString = [@"mj_" stringByAppendingString:selString];
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(leeSelString));
            method_exchangeImplementations(originalMethod, leeMethod);
        }];
    });
}

- (void)mj_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [self mj_pushViewController:viewController animated:animated];
}

@end
