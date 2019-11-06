//
//  BLMainTabBarViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/20.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMainTabBarViewController.h"

@interface BLMainTabBarViewController ()

@end

@implementation BLMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectedImage = [obj.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        obj.image = [obj.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([item.title isEqualToString:@"商城"]) {
        //每次点到商城则重置刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Mall_reset_refresh" object:nil];
    }
}

@end
