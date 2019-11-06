//
//  BLAnswerReportTopicTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAnswerReportTopicTableViewCell.h"
#import <YYWebImage.h>

@interface BLAnswerReportTopicTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;


@end

@implementation BLAnswerReportTopicTableViewCell

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
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:model.coverImg] placeholder:[UIImage imageNamed:@"b_placeholder"]];
    _titleLabel.text = model.title;
    _contentLabel.text = model.introduction;
    _numberLabel.text = [NSString stringWithFormat:@"%ld人在做 | 共%ld套", (long)model.doingNum, (long)model.setNum];
    _tagLabel.text = model.labelName;
    
}

@end
