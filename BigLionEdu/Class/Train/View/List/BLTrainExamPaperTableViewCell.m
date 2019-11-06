//
//  BLTrainExamPaperTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainExamPaperTableViewCell.h"

@interface BLTrainExamPaperTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *totalTime;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIButton *tagButton;
@end

@implementation BLTrainExamPaperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.totalTime.text = @"";
    self.priceLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(BLPaperModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.numberLabel.text = [NSString stringWithFormat:@"已完成%ld/%ld", model.doneCount, model.total];
    if ([model.isFree isEqualToString:@"1"]) {
        self.tagButton.hidden = NO;
        self.priceLabel.text = @"";
    }else {
        if ([model.isPurchase isEqualToString:@"1"]) {
            [self.tagButton setTitle:@"已购买" forState:UIControlStateNormal];
            self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",[ model.price doubleValue]];
            self.tagButton.hidden = NO;
        }else {
            self.priceLabel.text = @"";
            self.tagButton.hidden = YES;
        }
    }
    if ([model.duration integerValue] > 0) {
        self.totalTime.text = [NSString stringWithFormat:@"|  总时间%@分钟", model.duration];
    }else {
        self.totalTime.text = @"";
    }
    
    if ([model.isAdvance isEqualToString:@"1"] && !model.isStart) {
        self.titleLabel.textColor = [UIColor colorWithRed:207/255.0 green:214/255.0 blue:230/255.0 alpha:1.0];
        self.numberLabel.textColor = [UIColor colorWithRed:207/255.0 green:214/255.0 blue:230/255.0 alpha:1.0];
        self.totalTime.textColor = [UIColor colorWithRed:207/255.0 green:214/255.0 blue:230/255.0 alpha:1.0];
    }else {
        self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.numberLabel.textColor = [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
        self.totalTime.textColor = [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
    }
    
}

@end
