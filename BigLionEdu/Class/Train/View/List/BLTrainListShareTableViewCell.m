//
//  BLTrainListShareTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/17.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainListShareTableViewCell.h"
#import <SDWebImage.h>
#import "NTCatergory.h"

@implementation BLTrainListShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLCurriculumModel *)model {
    _model = model;
    self.titleLab.text = model.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:model.tutorImg?:@""]] placeholderImage:[UIImage imageNamed:@"coverImg"]];
    self.timeLab.text = @"";
    self.priceLab.text = [NSString stringWithFormat:@"￥%.lf", model.price.floatValue];
    self.numberLab.text = [NSString stringWithFormat:@"%ld人在观看", (long)model.salesNum];
    self.nameLab.text = model.tutorName;
}

@end
