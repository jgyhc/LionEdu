//
//  BLTopicAnalysisImageContentTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicAnalysisImageContentTableViewCell.h"

@interface BLTopicAnalysisImageContentTableViewCell ()



@end

@implementation BLTopicAnalysisImageContentTableViewCell

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
    
}

@end
