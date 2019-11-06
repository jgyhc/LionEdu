//
//  BLOrderDetailPriceTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderDetailPriceTableViewCell.h"

@implementation BLOrderDetailPriceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLOrderModel *)model {
    _model = model;
    self.expressPriceLab.text = [NSString stringWithFormat:@"￥%.2f", model.expressPrice.floatValue];
    self.totalPriceLab.text = [NSString stringWithFormat:@"￥%.2f", model.dealPrice.floatValue];
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f", model.dealPrice.floatValue];
}

@end
