//
//  BLGoodsDetailVideoCourseCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/5.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGoodsDetailVideoCourseCell.h"
#import <SDWebImage.h>
#import "NTCatergory.h"

@implementation BLGoodsDetailVideoCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.online_bg.hidden = self.onlineLab.hidden = YES;
    self.contentView.backgroundColor = self.backgroundColor = [UIColor nt_colorWithHexString:@"#F2F5F5"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLGoodsDetailVideoModel *)model {
    _model = model;
    self.jp.hidden = self.jp_bg.hidden = model.label.length > 0 ? NO : YES;
    self.jp.text =  model.label;
    self.titleLab.text = model.title;
    self.timeLab.text = [NSString stringWithFormat:@"课时：%@课时", model.courseHour];
    [self.courseImg sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:model.tutorImg?:@""]] placeholderImage: [UIImage imageNamed:@"b_placeholder"]];
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f", model.price.floatValue];
    self.saleLab.text = [NSString stringWithFormat:@"已售：%@", model.salesNum];
    self.nameLab.text = model.tutorName;
}

@end
