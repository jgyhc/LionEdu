//
//  BLMyInterestButtonTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/24.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyInterestButtonTableViewCell.h"

@interface BLMyInterestButtonTableViewCell ()




@end

@implementation BLMyInterestButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, 107 , 29);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:185/255.0 blue:0/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    gl.cornerRadius = 14.5;
    
    self.sureButton.clipsToBounds = YES;
    [self.sureButton.layer addSublayer:gl];
    [self.sureButton.layer insertSublayer:gl atIndex:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
