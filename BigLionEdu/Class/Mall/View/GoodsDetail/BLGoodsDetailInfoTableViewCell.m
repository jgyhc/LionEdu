//
//  BLGoodsDetailInfoTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGoodsDetailInfoTableViewCell.h"

@implementation BLGoodsDetailInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(BLGoodsDetailModel *)model {
    _model = model;
    self.priceLab.text = [NSString stringWithFormat:@"%.2lf", model.price.floatValue];
    self.titleLab.text = model.title;
    self.oPriceLab.text = [NSString stringWithFormat:@"%.2lf", model.originPrice.floatValue];
    self.saleAndStoreLab.text = [NSString stringWithFormat:@"销量：%@   库存：%@", model.salesNum, model.stock];
}

@end
