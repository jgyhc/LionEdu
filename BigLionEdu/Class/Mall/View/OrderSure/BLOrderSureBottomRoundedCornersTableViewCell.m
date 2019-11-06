//
//  BLOrderSureBottomRoundedCornersTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderSureBottomRoundedCornersTableViewCell.h"

@interface BLOrderSureBottomRoundedCornersTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation BLOrderSureBottomRoundedCornersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), 10) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), 10);
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.containerView.layer.mask = maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
