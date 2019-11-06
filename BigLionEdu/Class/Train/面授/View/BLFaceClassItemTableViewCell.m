//
//  BLFaceClassItemTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/26.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLFaceClassItemTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface BLFaceClassItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *headerBackImageView;

@property (weak, nonatomic) IBOutlet UIView *headerBackImageView1;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightIconLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *nameLabel;

@end

@implementation BLFaceClassItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLCurriculumModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.timeLabel.text = [NSString stringWithFormat:@"课时：%ld课时", (long)model.courseHour];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:model.tutorImg]] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf", model.price.floatValue];
    self.numberLabel.text = [NSString stringWithFormat:@"已售：%ld", (long)model.salesNum];
    self.rightIconLabel.hidden = YES;
    if (model.labelName) {
        self.rightIconLabel.hidden = NO;
        self.rightIconImageView.hidden = NO;
    } else {
        self.rightIconLabel.hidden = YES;
        self.rightIconImageView.hidden = YES;
    }
    self.rightIconLabel.text = model.labelName;
    self.headerBackImageView.hidden = self.headerBackImageView1.hidden = ![model.isMutipleTutor isEqualToString:@"1"];
    [self.nameLabel setTitle:model.tutorName forState:UIControlStateNormal];
}

@end
