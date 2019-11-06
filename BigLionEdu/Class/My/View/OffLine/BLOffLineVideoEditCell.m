//
//  BLOffLineVideoEditCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLOffLineVideoEditCell.h"

@implementation BLOffLineVideoEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.selectBtn addTarget:self action:@selector(bl_select:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLClassScheduleItemModel *)model {
    _model = model;
    self.titleLab.text = model.liveRecCourseTitle;
    self.timeLab.text = [NSString stringWithFormat:@"时长：%ld", model.hours];
    self.selectBtn.selected = model.isSelected;
}

- (void)bl_select:(UIButton *)sender {
    sender.selected = !sender.selected;
    _model.isSelected = sender.isSelected;
    [self.delegate BLOffLineVideoEditCellDidChange];
}


@end
