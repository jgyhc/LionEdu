//
//  BLMockDetailParsingTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLMockDetailParsingTableViewCell.h"
#import <YYWebImage.h>

@interface BLMockDetailParsingTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation BLMockDetailParsingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLMockItemModel *)model {
    _model = model;
    [_backgroundImageView yy_setImageWithURL:[NSURL URLWithString:model.liveImg] placeholder:[UIImage imageNamed:@"mkds_sm"]];
    _timeLabel.text = model.liveTimeSting;
}

@end
