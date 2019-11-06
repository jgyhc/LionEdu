//
//  BLGoodsDetailSXCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/8.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGoodsDetailSXCell.h"
#import <SDWebImage.h>

@implementation BLGoodsDetailSXCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLGoodsDetailSXModel *)model {
    _model = model;
    self.titleLab.text = model.tutorTitle;
    self.descLab.text = model.desc;
    self.priceLab.text = @"￥0.00";
    self.viewNumberLab.text = @"";
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:model.headImg?:@""]] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
    self.nameLab.text = model.name;
}

@end
