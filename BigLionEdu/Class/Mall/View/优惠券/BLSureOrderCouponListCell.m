//
//  BLSureOrderCouponListCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/23.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLSureOrderCouponListCell.h"
#import "NTCatergory.h"
#import <BlocksKit+UIKit.h>

@implementation BLSureOrderCouponListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userInteractionEnabled = YES;
    __weak typeof(self) wself = self;
    [self bk_whenTapped:^{
        [wself.delegate BLSureOrderCouponListCellDidSelected:wself.model];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
title    string    优惠券名称
validDay    int    有效期
isDiscount    string    1：折扣券， 2：满减券 等等
couponType    string    优惠券类型0普通券 1 新人券 2 推荐人券
saleValue    string    折扣值或者满减优惠值
isLimited    string    是有限制金额要求 1是 0否
overPrice    Double    限制金额（条件）
isSingle    string    优惠券是否复用 1是 0否
instruction    string    使用说明
isCanUse    string    是否可用1是 0否
endDate    date    到期时间
 */
- (void)setModel:(BLGoodsSureCouponModel *)model {
    _model = model;
    self.priceLab.text = model.saleValue;
    self.titleLab.text = model.title;
    // 1：折扣券， 2：满减券 等等
    if ([model.isDiscount isEqualToString:@"1"]) {
        self.typeLab.text = [NSString stringWithFormat:@"抵扣券"];
    } else if ([model.isDiscount isEqualToString:@"2"]) {
        if ([model.isLimited isEqualToString:@"1"]) {
            self.typeLab.text = [NSString stringWithFormat:@"满%@可用", model.overPrice];
        } else {
            self.typeLab.text = @"满减";
        }
    } else {
        self.typeLab.text = model.couponType;
    }
    self.timeLab.text = model.endDate;
    if (model.isCanUse == 0) {
        self.priceLab.textColor = self.rmb.textColor = [UIColor nt_colorWithHexString:@"#878C97"];
    } else {
        self.priceLab.textColor = self.rmb.textColor = [UIColor nt_colorWithHexString:@"#E63535"];
    }
    if (model.isSelected) {
        [self.bg setImage:[UIImage imageNamed:@"yhqxz"]];
    } else {
        [self.bg setImage:[UIImage imageNamed:@"yhq"]];
    }
}

@end
