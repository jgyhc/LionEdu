//
//  BLGoodsPaySuccessController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGoodsPaySuccessController.h"

@interface BLGoodsPaySuccessController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation BLGoodsPaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //拼团类型：0：单独购买，1：发起拼团，2：参加拼团
    if (self.groupType.integerValue > 0) {
        [self.button setTitle:@"邀请好友拼团" forState:UIControlStateNormal];
    }
}

- (IBAction)bl_viewOrder:(id)sender {
    if (self.groupType.integerValue > 0) {
        
    } else {
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLOrderListViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)bl_finished:(id)sender {
    if (self.backToController) {
        __block BOOL haveController = NO;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(self.backToController)]) {
                [self.navigationController popToViewController:obj animated:YES];
                haveController = YES;
                *stop = YES;
            }
        }];
        if (haveController == NO) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
