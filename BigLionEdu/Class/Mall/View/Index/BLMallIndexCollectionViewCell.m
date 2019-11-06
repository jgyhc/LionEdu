//
//  BLMallIndexCollectionViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMallIndexCollectionViewCell.h"
#import <YYWebImage.h>
#import <BlocksKit+UIKit.h>

@interface BLMallIndexCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *flag;

@end

@implementation BLMallIndexCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.flag setTitle:@"特\n惠" forState:UIControlStateNormal];
    self.flag.userInteractionEnabled = self.goodsImageView.userInteractionEnabled = NO;
    self.userInteractionEnabled = YES;
    __weak typeof(self) wself = self;
    [self bk_whenTapped:^{
        [wself.delegate BLMallIndexCollectionViewCellDidSelect:wself.model];
    }];
}

- (void)setModel:(BLGoodsModel *)model {
    _model = model;
    [_goodsImageView yy_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:model.coverImg?:@""]] placeholder:[UIImage imageNamed:@"f_placeholder"]];
    _titleLabel.text = model.title;
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [model.price doubleValue]];
    _infoLabel.text = [NSString stringWithFormat:@"%ld人付款", (long)model.salesNum];
    self.flag.hidden = model.labelName.length > 0 ? NO : YES;
    NSString *string = [NSString stringWithFormat:@"%@\n%@", [model.labelName substringToIndex:1],[model.labelName substringFromIndex:1]];
    [self.flag setTitle:string forState:UIControlStateNormal];
}


@end
