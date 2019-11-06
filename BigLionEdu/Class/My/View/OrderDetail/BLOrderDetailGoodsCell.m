//
//  BLOrderDetailGoodsCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLOrderDetailGoodsCell.h"
#import <SDWebImage.h>

@implementation BLOrderDetailGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLOrderGoodsModel *)model {
    _model = model;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:model.orderGoodsImg?:@""]] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
    self.titleLab.text = model.orderGoodsName;
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f", model.orderGoodsPrice.floatValue];
    self.numLab.text = [NSString stringWithFormat:@"x%@", model.goodsNum];
}

@end
