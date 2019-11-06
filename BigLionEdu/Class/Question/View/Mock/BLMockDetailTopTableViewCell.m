//
//  BLMockDetailTopTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLMockDetailTopTableViewCell.h"
#import <YYWebImage.h>

@interface BLMockDetailTopTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation BLMockDetailTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_signUpButton addTarget:self action:@selector(signUpEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)signUpEvent:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(signUpWithModel:)]) {
        [self.delegate signUpWithModel:self.model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLMockItemModel *)model {
    _model = model;
    [_timeButton setTitle:model.timeString forState:UIControlStateNormal];
    _titleLabel.text = model.title;
    if ([model.status isEqualToString:@"1"]) {//1.未报名
        [self.signUpButton setBackgroundColor:[UIColor whiteColor]];
        [self.signUpButton setTitleColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.signUpButton setTitle:@"立即报名" forState:UIControlStateNormal];
    }else {
        [self.signUpButton setTitle:@"已报名" forState:UIControlStateNormal];
        [self.signUpButton setBackgroundColor:[UIColor colorWithRed:243/255.0 green:152/255.0 blue:85/255.0 alpha:1.0]];
        [self.signUpButton setTitleColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    _countLabel.text = [NSString stringWithFormat:@"已有%ld人报名", model.registerNum];
    [_backgroundImageView yy_setImageWithURL:[NSURL URLWithString:model.img] placeholder:[UIImage imageNamed:@"mkds_bj"]];
}

@end
