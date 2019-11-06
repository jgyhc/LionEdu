//
//  BLTrainILeftItemTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainILeftItemTableViewCell.h"
#import <YYWebImage.h>

@interface BLTrainILeftItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backView0;

@property (weak, nonatomic) IBOutlet UIView *backView1;

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightIconLabel;

@end

@implementation BLTrainILeftItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(BLTrainBaseCoreLiveRecListModel *)model {
    _model = model;
    if ([model.isMutipleTutor integerValue] == 1) {
        _backView0.hidden = NO;
        _backView1.hidden = NO;
    }else {
        _backView0.hidden = YES;
        _backView1.hidden = YES;
    }
    _titleLabel.text = model.title;
    _subTitleLabel.text = [NSString stringWithFormat:@"开课时间：%@", model.liveStartDate];
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [model.price doubleValue]];
    _numberLabel.text = [NSString stringWithFormat:@"已售：%ld", [model.salesNum longValue]];
    [_bookImageView yy_setImageWithURL:[NSURL URLWithString:model.tutorImg] placeholder:[UIImage imageNamed:@"b_placeholder"]];
    _rightIconImageView.hidden = [model.isFree integerValue] == 1;
    _rightIconLabel.hidden = [model.isFree integerValue] == 1;;
}

@end
