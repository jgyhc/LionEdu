//
//  BLTrainShareDetailCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainShareDetailCell.h"

@implementation BLTrainShareDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLTrainCurriculumDetailModel *)model {
    _model = model;
    self.contentLab.attributedText = model.introduceAttr;
}

@end
