//
//  BLQuestionBankItemTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/25.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLQuestionBankItemTableViewCell.h"
#import <YYLabel.h>

@interface BLQuestionBankItemTableViewCell ()

@property (weak, nonatomic) IBOutlet YYLabel *label;

@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *redView;

@property (weak, nonatomic) IBOutlet UIButton *tagButton;
@end

@implementation BLQuestionBankItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label.numberOfLines = 0;
    _label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 48 - 67;//设置最大宽度
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLPaperModel *)model {
    _model = model;
    _label.attributedText = model.titleAttributeString;
    _subLabel.text = [NSString stringWithFormat:@"已完成 %ld/%ld", (long)model.doneCount, (long)model.total];
    
    if ([_model.isPurchase isEqualToString:@"1"] && [_model.isRare isEqualToString:@"0"]) {
        self.tagButton.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"有效时间：%@-%@", model.startEffectiveTimeString, model.endEffectiveTimeString];
        _redView.hidden = NO;
        _timeLabel.textColor = [UIColor colorWithRed:255/255.0 green:185/255.0 blue:0.0/255.0 alpha:1.0];
    } else if ([_model.isPurchaseRare isEqualToString:@"1"] && [_model.isRare isEqualToString:@"1"]) {
        self.tagButton.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"有效时间：%@-%@", model.startEffectiveTimeString, model.endEffectiveTimeString];
        _redView.hidden = NO;
        _timeLabel.textColor = [UIColor colorWithRed:255/255.0 green:185/255.0 blue:0.0/255.0 alpha:1.0];
    } else {
        self.tagButton.hidden = YES;
        _redView.hidden = YES;
        if ([model.price doubleValue] == 0 || [model.isFree isEqualToString:@"1"]) {
            _timeLabel.text = @"";
        }else {
            _timeLabel.text = [NSString stringWithFormat:@"￥%0.2f", [model.price doubleValue]];
            _timeLabel.textColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
        }
    }
    
    if ([model.isAdvance isEqualToString:@"1"] && !model.isStart) {
        self.subLabel.textColor = [UIColor colorWithRed:207/255.0 green:214/255.0 blue:230/255.0 alpha:1.0];
    }else {
        self.subLabel.textColor = [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
    }
    
    
    if ([model.isFree isEqualToString:@"1"]) {
        self.tagButton.hidden = NO;
        [self.tagButton setTitle:@"免费试做" forState:UIControlStateNormal];
    }
}



@end
