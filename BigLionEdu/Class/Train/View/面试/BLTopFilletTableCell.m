//
//  BLTopFilletTableCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/9.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTopFilletTableCell.h"
#import "NTCatergory.h"

@implementation BLTopFilletTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, NT_SCREEN_WIDTH - 10, 10) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), 10);
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.containerView.layer.mask = maskLayer;
}

@end
