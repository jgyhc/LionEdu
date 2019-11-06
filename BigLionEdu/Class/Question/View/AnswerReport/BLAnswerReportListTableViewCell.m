//
//  BLAnswerReportListTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAnswerReportListTableViewCell.h"

@interface BLAnswerReportListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@end

@implementation BLAnswerReportListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NSDictionary *)model {
    _model = model;
    _leftLabel.text = [model objectForKey:@"leftTitle"];
    _centerLabel.text = [model objectForKey:@"centerTitle"];
    _rightLabel.text = [model objectForKey:@"rightTitle"];
}

@end
