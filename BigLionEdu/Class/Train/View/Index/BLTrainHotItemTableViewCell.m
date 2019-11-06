//
//  BLTrainHotItemTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/11.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainHotItemTableViewCell.h"

@interface BLTrainHotItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;

@end

@implementation BLTrainHotItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLTrainCoreNewsModel *)model {
    _model = model;
    
    _titleLabel.attributedText = model.titleString;
    _hotImageView.hidden = (model.isHot == 0);
}

@end
