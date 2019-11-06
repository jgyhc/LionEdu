//
//  BLTrainMockTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainMockTableViewCell.h"

@interface BLTrainMockTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *topButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *allButton;

@end

@implementation BLTrainMockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLIndexTestModel *)model {
    _model = model;
    [_topButton setTitle:model.title forState:UIControlStateNormal];
    _titleLabel.text = model.content;
}

@end
