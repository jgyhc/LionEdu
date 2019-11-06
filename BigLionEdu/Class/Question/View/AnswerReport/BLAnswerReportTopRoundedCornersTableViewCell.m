//
//  BLAnswerReportTopRoundedCornersTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAnswerReportTopRoundedCornersTableViewCell.h"

@interface BLAnswerReportTopRoundedCornersTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *cornersView;


@end

@implementation BLAnswerReportTopRoundedCornersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(self.cornersView.bounds), 15) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15,15)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.cornersView.bounds), 15);
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.cornersView.layer.mask = maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
