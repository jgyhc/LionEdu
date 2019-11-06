//
//  BLOrderSureDistributionTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderSureDistributionTableViewCell.h"

@implementation BLOrderSureDistributionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(id)model {
    _model = model;
    if ([model isKindOfClass:[BLGoodsSureConfirmModel class]]) {
        BLGoodsSureConfirmModel *obj = (BLGoodsSureConfirmModel *)model;
        if (obj.expressFee.floatValue <= 0) {
            self.priceLab.text = @"快递 包邮";
        } else {
            self.priceLab.text = [NSString stringWithFormat:@"快递 %.2f", obj.expressFee.floatValue];
        }
        if (obj.isPaper) {
            self.priceLab.text = @"在线商品";
        }
    } else if ([model isKindOfClass:[BLPaperModel class]]) {
        self.priceLab.text = @"在线商品";
    }
}

@end
