//
//  BLTopicAnalysisTextTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicAnalysisTextTableViewCell.h"
#import <YYAsyncLayer.h>

@interface BLTopicAnalysisTextTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;


@end

@implementation BLTopicAnalysisTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(BLTopicModel *)model {
    _model = model;
    if ([model.type isEqualToString:@"填空"] || [model.type isEqualToString:@"简答"]) {
        _valueLabel.text = model.answerString;
    }else {
        _valueLabel.text = model.answer;
    }
    
}
@end
