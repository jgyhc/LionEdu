//
//  BLMealButtonTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/13.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMealButtonTableViewCell.h"

@interface BLMealButtonTableViewCell ()

@property (nonatomic, strong) CAGradientLayer *bgLayer;

@end

@implementation BLMealButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView layoutIfNeeded];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,self.sureButton.bounds.size.width, 48);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:185/255.0 blue:0/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    gl.cornerRadius = 24;
    self.sureButton.clipsToBounds = YES;
    _bgLayer = gl;
    [self.sureButton.layer addSublayer:gl];
    [self.sureButton.layer insertSublayer:gl atIndex:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
