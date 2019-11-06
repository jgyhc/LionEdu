//
//  BLPaperHeaderTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLPaperHeaderTableViewCell.h"
#import <YYWebImage.h>

@interface BLPaperHeaderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation BLPaperHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupRoundedCornersWithView:self.tagLabel cutCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight borderColor:[UIColor clearColor] borderWidth:8 viewColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLQuestionsModel *)model {
    _model = model;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:model.img] placeholder:[UIImage imageNamed:@"f_placeholder"]];
    _titleLabel.text = model.title;
    _subLabel.text = model.introduction;
    _countLabel.text = [NSString stringWithFormat:@"%ld人在做 | 共%ld套", (long)model.doingNum, model.setNum];
    _priceLabel.attributedText = model.priceAttString;
    if (model.labelName && model.labelName.length > 0) {
        _tagLabel.text = model.labelName;
        _tagLabel.hidden = NO;
    }else {
        _tagLabel.hidden = YES;
    }
}

/**
 按钮的圆角设置

 @param view view类控件
 @param rectCorner UIRectCorner要切除的圆角
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @param viewColor view类控件颜色
 */
- (void)setupRoundedCornersWithView:(UIView *)view cutCorners:(UIRectCorner)rectCorner borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth viewColor:(UIColor *)viewColor{

    CAShapeLayer *mask=[CAShapeLayer layer];
    UIBezierPath * path= [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(15,10)];
    mask.path=path.CGPath;
    mask.frame=view.bounds;

    CAShapeLayer *borderLayer=[CAShapeLayer layer];
    borderLayer.path=path.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = borderColor.CGColor;
    borderLayer.lineWidth = borderWidth;
    borderLayer.frame = view.bounds;
    view.layer.mask = mask;
    [view.layer addSublayer:borderLayer];
}

@end
