//
//  BLGoodsPaySuccessController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGoodsPayFaileController.h"

@interface BLGoodsPayFaileController ()

@end

@implementation BLGoodsPayFaileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (IBAction)bl_back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
