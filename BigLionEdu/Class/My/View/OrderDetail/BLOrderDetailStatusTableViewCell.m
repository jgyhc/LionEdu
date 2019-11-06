//
//  BLOrderDetailStatusTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderDetailStatusTableViewCell.h"

@implementation BLOrderDetailStatusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLOrderModel *)model {
    //拼团的当前状态:0:拼团中，1：拼团成功，2：拼团失败，3:已退款, 4:已发货 5：退款状态，6：发货成功
    _model = model;
    NSInteger groupStatus = model.orderGoodsList.firstObject.groupStatus.integerValue;
    if (groupStatus == 0) {
        self.groupStatusLab.text = @"拼团中";
    } else if (groupStatus == 1) {
        self.groupStatusLab.text = @"拼团成功";
    } else if (groupStatus == 2) {
        self.groupStatusLab.text = @"拼团失败";
    } else if (groupStatus == 3) {
        self.groupStatusLab.text = @"拼团已退款";
    } else if (groupStatus == 4) {
        self.groupStatusLab.text = @"拼团已发货";
    } else if (groupStatus == 5) {
        self.groupStatusLab.text = @"大狮解小吼一声：拼团失败，确认退款中，原路返回退款中";
    } else if (groupStatus == 6) {
        self.groupStatusLab.text = @"拼团发货成功";
    }
    //订单类型：0:正常订单,1：拼团订单
    if (model.singleType <= 0) {
        self.groupStatusLab.text = @"";
    }
    //    订单状态(1：待付款，2：待发货，3：待收货，4：退款中，5：交易关闭，6：交易成功，7：交易失败)
    if ([model.status isEqualToString:@"1"]) {
        self.statusLab.text = @"待付款";
        self.icon.image = [UIImage imageNamed:@"ddxq_dfk"];
    } else if ([model.status isEqualToString:@"2"]) {
        self.statusLab.text = @"待发货";
        self.icon.image = [UIImage imageNamed:@"ddxq_dfh"];
    } else if ([model.status isEqualToString:@"3"]) {
        self.statusLab.text = @"待收货";
        self.icon.image = [UIImage imageNamed:@"ddxq_yfh"];
    } else if ([model.status isEqualToString:@"4"]) {
        self.statusLab.text = @"退款中";
        self.icon.image = [UIImage imageNamed:@"ddxq_jygb"];
    } else if ([model.status isEqualToString:@"5"]) {
        self.statusLab.text = @"交易关闭";
        self.icon.image = [UIImage imageNamed:@"ddxq_jygb"];
    } else if ([model.status isEqualToString:@"6"]) {
        self.statusLab.text = @"交易成功";
        self.icon.image = [UIImage imageNamed:@"ddxq_jycg"];
    } else if ([model.status isEqualToString:@"7"]) {
        self.statusLab.text = @"交易失败";
        self.icon.image = [UIImage imageNamed:@"ddxq_jygb"];
    }
}

@end
