//
//  BLOrderDetailInfoTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderDetailInfoTableViewCell.h"

@implementation BLOrderDetailInfoTableViewCell

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
    self.orderNo.text = [NSString stringWithFormat:@"订单编号：%@", model.orderCode];
    self.timeLab.text = [NSString stringWithFormat:@"下单时间：%@", model.orderTime];
    self.payWayLab.text = [NSString stringWithFormat:@"支付方式：%@", model.payMethod];
}

@end
