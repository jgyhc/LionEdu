//
//  BLPaperItemTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLPaperItemTableViewCell.h"
#import <YYLabel.h>
#import <Masonry.h>
#import <YYText.h>

@interface BLPaperItemTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *totalTime;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIButton *tagButton;

@property (nonatomic, strong) UIButton *tagLabel;

@property (nonatomic, strong) YYLabel *label;
@end

@implementation BLPaperItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.totalTime.text = @"";
    self.priceLabel.text = @"";
    _titleLabel.text = @"";
    _tagButton.hidden = YES;
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(18);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).mas_offset(-45);
    }];
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.label.mas_right).mas_offset(9);
        make.height.mas_equalTo(13);
        make.top.mas_equalTo(self.label);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(BLPaperModel *)model {
    _model = model;
//    self.titleLabel.text = model.title;
    
    self.numberLabel.text = [NSString stringWithFormat:@"已完成%ld/%ld", (long)model.doneCount, (long)model.total];
    if (model.isAllBuy) {
        self.priceLabel.text = @"";
        self.tagLabel.hidden = YES;
    }else {
        if ([model.isFree isEqualToString:@"1"]) {
            self.tagLabel.hidden = NO;
            [self.tagLabel setTitle:@"免费试炼" forState:UIControlStateNormal];
            self.priceLabel.text = @"";
        }else {
            if ([model.isPurchase isEqualToString:@"1"]) {
                [self.tagLabel setTitle:@"已购买" forState:UIControlStateNormal];
                self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",[ model.price doubleValue]];
                self.tagLabel.hidden = NO;
            }else {
                self.priceLabel.text = @"";
                self.tagLabel.hidden = YES;
            }
        }
    }
    
    if ([model.isRare isEqualToString:@"1"]) {
        if ([model.isPurchaseRare isEqualToString:@"1"]) {
            self.tagLabel.hidden = NO;
        }else {
            self.tagLabel.hidden = YES;
        }
    }
    if ([model.duration integerValue] > 0) {
        self.totalTime.text = [NSString stringWithFormat:@"|  总时间%@分钟", model.duration];
    }else {
        self.totalTime.text = @"";
    }
    
    if ([model.isAdvance isEqualToString:@"1"] && !model.isStart) {
        model.titleContentAttributeString.yy_color = [UIColor colorWithRed:207/255.0 green:214/255.0 blue:230/255.0 alpha:1.0];
        self.numberLabel.textColor = [UIColor colorWithRed:207/255.0 green:214/255.0 blue:230/255.0 alpha:1.0];
        self.totalTime.textColor = [UIColor colorWithRed:207/255.0 green:214/255.0 blue:230/255.0 alpha:1.0];
    }else {
        model.titleContentAttributeString.yy_color= [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.numberLabel.textColor = [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
        self.totalTime.textColor = [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
    }
    self.label.attributedText = model.titleAttributeString;
}

- (YYLabel *)label {
    if (!_label) {
        _label = [[YYLabel alloc] init];
        _label.numberOfLines = 0;
        _label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 60;
    }
    return _label;
}

- (UIButton *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tagLabel setBackgroundImage:[UIImage imageNamed:@"st_bq"] forState:UIControlStateNormal];
        [_tagLabel setContentEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 3)];
        _tagLabel.titleLabel.font = [UIFont systemFontOfSize:10];
        [_tagLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _tagLabel;
}

@end
