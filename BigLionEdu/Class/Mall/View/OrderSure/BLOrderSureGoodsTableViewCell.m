//
//  BLOrderSureGoodsTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderSureGoodsTableViewCell.h"
#import <SDWebImage.h>

@implementation BLOrderSureGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(id)model {
    _model = model;
    if ([model isKindOfClass:[BLGoodsSureModel class]]) {
        BLGoodsSureModel *obj = (BLGoodsSureModel *)model;
        self.titleLab.text = obj.title;
        if ([obj.coverImg hasPrefix:@"http"]) {
            [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:obj.coverImg] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
        } else {
            [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:obj.coverImg?:@""]] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
        }
        self.priceLab.text = [NSString stringWithFormat:@"￥%@", obj.price];
        if (obj.goodsNum > 0) {
            self.numLab.text = [NSString stringWithFormat:@"x%ld", obj.goodsNum];
        }
    } else if ([model isKindOfClass:[BLPaperModel class]]) {
        BLPaperModel *obj = (BLPaperModel *)model;
        self.titleLab.text = obj.title;
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:obj.coverImg?:@""]] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
        self.priceLab.text = [NSString stringWithFormat:@"￥%.2lf", obj.price.floatValue];
        self.numLab.text = @"x1";
    }
}

@end
