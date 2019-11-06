//
//  BLAnswerReportClassTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAnswerReportClassTableViewCell.h"
#import <YYWebImage.h>

@interface BLAnswerReportClassTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *shawView1;
@property (weak, nonatomic) IBOutlet UIView *shaw2View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftSpace;

@end

@implementation BLAnswerReportClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLAnswerReportQuestionItemModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    _timeLabel.text = [NSString stringWithFormat:@"开播时间：%@~%@", model.startTimeString, model.endTimeString];
    if ([model.isMutipleTutor isEqualToString:@"1"]) {
        _shaw2View.hidden = NO;
        _shawView1.hidden = NO;
    }else {
        _shaw2View.hidden = YES;
        _shawView1.hidden = YES;
    }
    if (model.labelName && model.labelName.length > 0) {
        self.tagLabel.text = model.labelName;
        self.tagLabel.hidden = NO;
        self.tagImageView.hidden = NO;
        _titleLeftSpace.constant = 20;
    }else {
        self.tagLabel.hidden = YES;
        self.tagImageView.hidden = YES;
        _titleLeftSpace.constant = 10;
    }
    [self.contentView layoutIfNeeded];
    
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:model.coverImg] placeholder:[UIImage imageNamed:@"b_placeholder"]];
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.2lf", [model.price doubleValue]];
    _numberLabel.text = [NSString stringWithFormat:@"已售：%ld", (long)model.salesNum];
}


@end
