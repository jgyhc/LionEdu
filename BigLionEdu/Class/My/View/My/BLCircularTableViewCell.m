//
//  BLCircularTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLCircularTableViewCell.h"

@interface BLCircularTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation BLCircularTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), 10) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
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
