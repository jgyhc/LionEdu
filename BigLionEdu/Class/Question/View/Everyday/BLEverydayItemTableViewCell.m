//
//  BLEverydayItemTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/5.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLEverydayItemTableViewCell.h"

@interface BLEverydayItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation BLEverydayItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,72,25);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:185/255.0 blue:0/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    gl.cornerRadius = 12.5;
    
    [self.button.layer addSublayer:gl];
    self.button.layer.cornerRadius = 12.5;
    [self.button.layer insertSublayer:gl atIndex:0];
    self.button.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLTopicModel *)model {
    _model = model;
    _titleLabel.attributedText = model.titleString;
    _subTitleLabel.text = [NSString stringWithFormat:@"%ld人在做", model.dailyNum];
}


@end
