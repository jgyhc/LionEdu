//
//  BLOrderSurePayWayTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderSurePayWayTableViewCell.h"

@implementation BLOrderSurePayWayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLGoodsSurePayWayModel *)model {
    _model = model;
    [self.icon setImage:[UIImage imageNamed:model.icon]];
    if ([model.icon isEqual:@"wx"]) {
        self.titleLab.text = @"微信支付";
    } else {
        self.titleLab.text = @"支付宝支付";
    }
    if (model.select) {
        self.selectIcon.image = [UIImage imageNamed:@"s_c"];
    } else {
        self.selectIcon.image = [UIImage imageNamed:@"my_wxz"];
    }
}

@end
