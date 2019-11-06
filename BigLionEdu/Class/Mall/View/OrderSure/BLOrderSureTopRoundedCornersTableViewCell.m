//
//  BLOrderSureTopRoundedCornersTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderSureTopRoundedCornersTableViewCell.h"

@interface BLOrderSureTopRoundedCornersTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation BLOrderSureTopRoundedCornersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), 10) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), 10);
    maskLayer.path = maskPath.CGPath;
    self.containerView.layer.mask = maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
