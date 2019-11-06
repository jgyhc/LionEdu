//
//  BLOrderSureCouponsTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderSureCouponsTableViewCell.h"

@implementation BLOrderSureCouponsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLGoodsSureConfirmModel *)model {
    _model = model;
    if (model.couponList.count <= 0) {
       self.priceLab.text = @"暂无可选优惠券";
    } else {
        if (model.discountPrice > 0) {
            self.priceLab.text = [NSString stringWithFormat:@"已优惠%.2f元", model.discountPrice];
        } else {
            self.priceLab.text = @"选择优惠券";
        }
    }
}

@end
