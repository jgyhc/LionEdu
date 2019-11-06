//
//  BLTopicAnalysisVideoContentTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/20.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTopicAnalysisVideoContentTableViewCell.h"

@interface BLTopicAnalysisVideoContentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;

@end

@implementation BLTopicAnalysisVideoContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _coverImageView.tag = 1001;
    _coverImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerDidSelectPlayer:)];
    [_coverImageView addGestureRecognizer:tap];
}

- (void)handlerDidSelectPlayer:(UITapGestureRecognizer *)tap {
    _playerImageView.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tappedCoverOnTheTableViewCell:model:)]) {
        [self.delegate tappedCoverOnTheTableViewCell:self model:_model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLTopicVideoModel *)model {
    _model = model;
    
}

@end
