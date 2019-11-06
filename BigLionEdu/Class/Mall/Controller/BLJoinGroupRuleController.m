
//
//  BLJoinGroupRuleController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/6.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLJoinGroupRuleController.h"

@interface BLJoinGroupRuleController ()
@property (weak, nonatomic) IBOutlet UILabel *ruleLab;

@end

@implementation BLJoinGroupRuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拼团规则";
    self.ruleLab.text = self.rule;
}


@end
