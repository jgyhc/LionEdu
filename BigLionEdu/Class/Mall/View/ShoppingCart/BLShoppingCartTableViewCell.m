//
//  BLShoppingCartTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLShoppingCartTableViewCell.h"
#import <SDWebImage.h>

@interface BLShoppingCartTableViewCell ()


@end

@implementation BLShoppingCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.selectBtn addTarget:self action:@selector(bl_select:) forControlEvents:UIControlEventTouchUpInside];
    self.goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImgView.clipsToBounds = YES;
    [self.numberView setOrderSureNumberViewHandler:^(NSInteger num) {
        self.model.goodsNum = num;
        if (self.delegate && [self.delegate respondsToSelector:@selector(bl_ShoppingCartSelectItem:)]) {
            [self.delegate bl_ShoppingCartSelectItem:self.model];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(BLCartModel *)model {
    _model = model;
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:model.coverImg?:@""]] placeholderImage:[UIImage imageNamed:@"f_placeholder"]];
    self.goodsNameLab.text = model.title;
    self.priceLab.text = [NSString stringWithFormat:@"￥%@", model.cartPrice.stringValue];
    self.numberView.quantityLabel.text = [NSString stringWithFormat:@"%ld", (long)model.goodsNum];
    self.selectBtn.selected = model.isSelect;
    if (model.type == 0) {
        self.numberView.userInteractionEnabled = YES;
    } else {
        self.numberView.userInteractionEnabled = NO;
    }
}

- (void)bl_select:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.model.isSelect = sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(bl_ShoppingCartSelectItem:)]) {
        [self.delegate bl_ShoppingCartSelectItem:nil];
    }
}

@end
