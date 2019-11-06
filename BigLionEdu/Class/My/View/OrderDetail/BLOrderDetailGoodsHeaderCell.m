//
//  BLOrderDetailGoodsHeaderCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLOrderDetailGoodsHeaderCell.h"
#import "NTCatergory.h"

@interface BLOrderDetailGoodsHeaderCell ()
@property (weak, nonatomic) IBOutlet UIView *contrainerView;

@end

@implementation BLOrderDetailGoodsHeaderCell

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
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, NT_SCREEN_WIDTH - 10, 40) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.contrainerView.bounds), 40);
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.contrainerView.layer.mask = maskLayer;
}

@end
