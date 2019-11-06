//
//  BLAnswerReportClassificationTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAnswerReportClassificationTableViewCell.h"

@interface BLAnswerReportClassificationTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *centerButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;


@end

@implementation BLAnswerReportClassificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _leftButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _leftButton.layer.shadowColor = [UIColor colorWithRed:245/255.0 green:206/255.0 blue:170/255.0 alpha:1.0].CGColor;
    _leftButton.layer.shadowOffset = CGSizeMake(0,2);
    _leftButton.layer.shadowOpacity = 1;
    _leftButton.layer.shadowRadius = 4;
    _leftButton.layer.cornerRadius = 5;
    
    _centerButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _centerButton.layer.shadowColor = [UIColor colorWithRed:245/255.0 green:206/255.0 blue:170/255.0 alpha:1.0].CGColor;
    _centerButton.layer.shadowOffset = CGSizeMake(0,2);
    _centerButton.layer.shadowOpacity = 1;
    _centerButton.layer.shadowRadius = 4;
    _centerButton.layer.cornerRadius = 5;
    
    _rightButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _rightButton.layer.shadowColor = [UIColor colorWithRed:245/255.0 green:206/255.0 blue:170/255.0 alpha:1.0].CGColor;
    _rightButton.layer.shadowOffset = CGSizeMake(0,2);
    _rightButton.layer.shadowOpacity = 1;
    _rightButton.layer.shadowRadius = 4;
    _rightButton.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)rightEvent:(id)sender {
    if ([_model.isManual isEqualToString:@"1"]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightEvent)]) {
        [self.delegate rightEvent];
    }
}

- (IBAction)centerEvent:(id)sender {
    if ([_model.isManual isEqualToString:@"1"]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(centerEvent)]) {
        [self.delegate centerEvent];
    }
}

- (IBAction)leftEvent:(id)sender {
    if ([_model.isManual isEqualToString:@"1"]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftEvent)]) {
        [self.delegate leftEvent];
    }
}

- (void)setNoInteractionWithButton:(UIButton *)button {
    button.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    button.layer.shadowColor = [UIColor whiteColor].CGColor;
    [button setTitleColor:[UIColor colorWithRed:197/255.0 green:196/255.0 blue:196/255.0 alpha:1.0] forState:UIControlStateNormal];
}

- (void)setInteractionWithButton:(UIButton *)button {
    button.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    button.layer.shadowColor = [UIColor colorWithRed:245/255.0 green:206/255.0 blue:170/255.0 alpha:1.0].CGColor;
    [button setTitleColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateNormal];
}

- (void)setModel:(BLAnswerReportModel *)model {
    _model = model;
    if ([_model.isManual isEqualToString:@"1"]) {//需要人工干预
        [self setNoInteractionWithButton:_leftButton];
        [self setNoInteractionWithButton:_centerButton];
        [self setNoInteractionWithButton:_rightButton];
    }else {
        [self setInteractionWithButton:_leftButton];
        [self setInteractionWithButton:_centerButton];
        [self setInteractionWithButton:_rightButton];
    }
}

@end
