//
//  BLTrainItemTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainItemTableViewCell.h"
#import <YYWebImage.h>

@interface BLTrainItemTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftSpace;

@property (weak, nonatomic) IBOutlet UIView *backView0;

@property (weak, nonatomic) IBOutlet UIView *backView1;

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *leftIconImageView;


@property (weak, nonatomic) IBOutlet UILabel *leftIconLabel;
@end


@implementation BLTrainItemTableViewCell

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
    _titleLabel.text = [NSString stringWithFormat:@"  %@", model.title];
    if ([model.type integerValue] == 0) {//直播    0：直播， 1：录播，2：课程， 3：狮享
         _subTitleLabel.text = [NSString stringWithFormat:@"开课时间：%@", model.liveStartDate];
    }else if ([model.type integerValue] == 1 ||[model.type integerValue] == 2) {
        _subTitleLabel.text = [NSString stringWithFormat:@"课时：%@", model.courseHour];
    }

    
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [model.price doubleValue]];
    _numberLabel.text = [NSString stringWithFormat:@"已售：%ld", [model.salesNum longValue]];
    [_bookImageView yy_setImageWithURL:[NSURL URLWithString:model.tutorImg] placeholder:[UIImage imageNamed:@"b_placeholder"]];
    _leftIconImageView.hidden = [model.isFree integerValue] == 1;
//    _leftIconLabel.hidden = [model.isFree integerValue] == 1;
}


@end
