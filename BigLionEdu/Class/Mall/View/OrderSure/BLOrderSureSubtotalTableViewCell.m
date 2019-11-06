//
//  BLOrderSureSubtotalTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderSureSubtotalTableViewCell.h"

@implementation BLOrderSureSubtotalTableViewCell

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
    self.numLab.text = [NSString stringWithFormat:@"共%ld件", model.buyNumber];
    self.priceLab.text = [NSString stringWithFormat:@"%.2f", model.price];
}

@end
