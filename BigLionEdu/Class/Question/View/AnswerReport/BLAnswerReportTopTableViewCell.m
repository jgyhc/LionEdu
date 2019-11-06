//
//  BLAnswerReportTopTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAnswerReportTopTableViewCell.h"

@interface BLAnswerReportTopTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *scoreView;

@property (weak, nonatomic) IBOutlet UIView *correctView;
@property (weak, nonatomic) IBOutlet UILabel *correctBottomLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeBottomLabel;

@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;

@property (weak, nonatomic) IBOutlet UILabel *kscjLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *time1Label;

@property (weak, nonatomic) IBOutlet UILabel *delayLabel;
@property (weak, nonatomic) IBOutlet UILabel *delayLabel1;
@end

@implementation BLAnswerReportTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _containerView.layer.shadowColor = [UIColor colorWithRed:245/255.0 green:206/255.0 blue:170/255.0 alpha:1.0].CGColor;
    _containerView.layer.shadowOffset = CGSizeMake(0,2);
    _containerView.layer.shadowOpacity = 1;
    _containerView.layer.shadowRadius = 4;
    _containerView.layer.cornerRadius = 15;
    
    _scoreView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
    _scoreView.layer.shadowOffset = CGSizeMake(0,2);
    _scoreView.layer.shadowOpacity = 1;
    _scoreView.layer.shadowRadius = 5;
    _scoreView.layer.borderWidth = 0.5;
    _scoreView.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0].CGColor;
    
    _correctView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
    _correctView.layer.shadowOffset = CGSizeMake(0,2);
    _correctView.layer.shadowOpacity = 1;
    _correctView.layer.shadowRadius = 5;
    _correctView.layer.borderWidth = 0.5;
    _correctView.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0].CGColor;
    
    _gradeLabel.font = [UIFont boldSystemFontOfSize:43.5];
    _gradeLabel.hidden = YES;
    _gradeBottomLabel.hidden = YES;
    _kscjLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLAnswerReportModel *)model {
    _model = model;
    _gradeLabel.text = [NSString stringWithFormat:@"%@", model.score];
    _accuracyLabel.text = [NSString stringWithFormat:@"%@%%",  model.accuracy];
    _titleLabel.text = [NSString stringWithFormat:@"练习类型：%@", model.title];
    _timeLabel.text = [NSString stringWithFormat:@"考试时间：%@", model.time];
    _time1Label.text = [NSString stringWithFormat:@"交卷时间：%@", model.submissionTimeStr];
    if ([model.isManual isEqualToString:@"1"]) {
        _gradeLabel.hidden = YES;
        _gradeBottomLabel.hidden = YES;
        _delayLabel.hidden = NO;
        _delayLabel1.hidden = NO;
        _accuracyLabel.text = @"延时展示";
        _correctBottomLabel.text = @"正确率";
        _kscjLabel.hidden = YES;
    }else {
        _kscjLabel.hidden = NO;
        _gradeLabel.hidden = NO;
        _gradeBottomLabel.hidden = NO;
        _delayLabel.hidden = YES;
        _delayLabel1.hidden = YES;
        _accuracyLabel.text = [NSString stringWithFormat:@"%@%%",  model.accuracy];
        _correctBottomLabel.text = @"正确率";
    }
}

@end
