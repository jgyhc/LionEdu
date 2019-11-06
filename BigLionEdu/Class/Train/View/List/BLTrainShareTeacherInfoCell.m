//
//  BLTrainShareTeacherInfoCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainShareTeacherInfoCell.h"
#import <SDWebImage.h>

@implementation BLTrainShareTeacherInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLTrainShareDetailTutorModel *)model {
    _model = model;
    self.nameLab.text = model.name;
    self.descLab.text = model.desc;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:model.headImg?:@""]] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
}

@end
