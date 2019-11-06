//
//  BLCouponsTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/29.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLCouponsTableViewCell.h"

@implementation BLCouponsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)action_useCoupons:(id)sender {
    [self.delegate toUserCoupons];
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
-(void)setModel:(BLMyCouponslistModel *)model{
    
    self.MoneyLab.text = model.saleValue;
    self.titLab.text = model.title;
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
        if ([model.couponType isEqualToString:@"0"]) {
            self.typeLab.text = @"普通券";
        } else if ([model.couponType isEqualToString:@"1"]) {
            self.typeLab.text = @"新人券";
        } else if ([model.couponType isEqualToString:@"2"]) {
            self.typeLab.text = @"推荐人券";
        } else {
            self.typeLab.text = @"普通券";
        }
    }
//    self.timeLab.text = model.validDay;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"有效期至：yyyy-MM-dd";
    NSDate *valiDate = [NSDate dateWithTimeIntervalSinceNow:model.validDay.integerValue * 24 * 60 * 60];
    self.timeLab.text = [formatter stringFromDate:valiDate];
}

@end
