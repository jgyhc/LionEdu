//
//  BLOrderHeaderCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLOrderHeaderCell.h"
#import "NTCatergory.h"

@implementation BLOrderHeaderCell

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
    maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), 40);
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.containerView.layer.mask = maskLayer;
}

- (void)setModel:(BLOrderModel *)model {
    _model = model;
    self.orderNoLab.text = [NSString stringWithFormat:@"订单号：%@", model.orderCode];
    
//    订单状态(1：待付款，2：待发货，3：待收货，4：退款中，5：交易关闭，6：交易成功，7：交易失败)
    if ([model.status isEqualToString:@"1"]) {
        self.statusLa.text = @"待付款";
    } else if ([model.status isEqualToString:@"2"]) {
        self.statusLa.text = @"待发货";
    } else if ([model.status isEqualToString:@"3"]) {
        self.statusLa.text = @"待收货";
    } else if ([model.status isEqualToString:@"4"]) {
        self.statusLa.text = @"退款中";
    } else if ([model.status isEqualToString:@"5"]) {
        self.statusLa.text = @"交易关闭";
    } else if ([model.status isEqualToString:@"6"]) {
        self.statusLa.text = @"交易成功";
    } else if ([model.status isEqualToString:@"7"]) {
        self.statusLa.text = @"交易失败";
    }
}

@end
