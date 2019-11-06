//
//  BLOrderDetailAddressTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderDetailAddressTableViewCell.h"

@implementation BLOrderDetailAddressTableViewCell

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
    self.nameLab.text = [NSString stringWithFormat:@"%@    %@", model.name,model.mobile];
    self.addressLab.text = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city,model.district, model.detail];
}

@end
