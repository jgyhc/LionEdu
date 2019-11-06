//
//  BLOrderSureAddressTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderSureAddressTableViewCell.h"

@implementation BLOrderSureAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLAddressModel *)model {
    _model = model;
    if (model.Id > 0) {
        self.nameLab.text = model.name;
        self.phoneLab.text = model.mobile;
        self.addressLab.text = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city, model.district, model.detail];
    } else {
        self.nameLab.text = @"请添加地址";
        self.phoneLab.text = @"";
        self.addressLab.text = @"";
    }
}

@end
