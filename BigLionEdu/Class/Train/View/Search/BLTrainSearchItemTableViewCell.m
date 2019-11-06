//
//  BLTrainSearchItemTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainSearchItemTableViewCell.h"

@interface BLTrainSearchItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation BLTrainSearchItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLPaperModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    _contentLabel.text = [NSString stringWithFormat:@"已完成%ld/%ld", model.doneCount, model.total];
}

@end
