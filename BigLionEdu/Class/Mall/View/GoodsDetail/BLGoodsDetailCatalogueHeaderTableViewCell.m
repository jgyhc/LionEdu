//
//  BLGoodsDetailCatalogueHeaderTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGoodsDetailCatalogueHeaderTableViewCell.h"

@implementation BLGoodsDetailCatalogueHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NSMutableAttributedString *)model {
    _model = model;
    self.contentLab.attributedText = model;
}

@end
