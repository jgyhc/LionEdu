//
//  BLTrainListVideoTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/14.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainListVideoTableViewCell.h"
#import <SDWebImage.h>
#import "FKTask.h"

@implementation BLTrainListVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.downBtn addTarget:self action:@selector(bl_downLoad) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLCurriculumModel *)model {
    _model = model;
    self.titleLab.text = model.title;
    self.timeLab.text = [NSString stringWithFormat:@"课时：%ld课时", (long)model.courseHour];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:model.tutorImg]] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2lf", model.price.floatValue];
    self.saleNum.text = [NSString stringWithFormat:@"已售：%ld", (long)model.salesNum];
    self.rightTag.hidden = YES;
    if (model.labelName) {
        self.tagText.hidden = NO;
        self.tagImg.hidden = NO;
    } else {
        self.tagText.hidden = YES;
        self.tagImg.hidden = YES;
    }
    self.tagText.text = model.labelName;
    self.shadow1.hidden = self.shadow2.hidden = ![model.isMutipleTutor isEqualToString:@"1"];
    [self.nameLab setTitle:model.tutorName forState:UIControlStateNormal];
    if ([model.isFree isEqualToString:@"1"]) {
        self.freeIcon.hidden = NO;
        self.freeLab.hidden = NO;
    } else {
        self.freeIcon.hidden = YES;
        self.freeLab.hidden = YES;
    }
    
    if (model.noteLocation.length > 0 || [model.isFree isEqualToString:@"1"]) {
        self.line.hidden = NO;
    } else {
        self.line.hidden = NO;
    }
    if (model.noteStateStr.length > 0) {
        self.downBtn.hidden = NO;
    } else {
        self.downBtn.hidden = YES;
    }
    [self.downBtn setTitle:model.noteStateStr forState:UIControlStateNormal];
}

- (void)bl_downLoad {
    
}

@end
