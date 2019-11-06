//
//  BLHotLinesTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/12.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLHotLinesTableViewCell.h"

@interface BLHotLinesTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation BLHotLinesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLNewsDTOListModel *)model {
    _model = model;
    
    _titleLabel.text = model.title;
    if ([model.isHot isEqualToString:@"1"]) {
        _hotImageView.hidden = NO;
    }else {
        _hotImageView.hidden = YES;
    }
    
    _timeLabel.text = model.createTime;
}

@end
