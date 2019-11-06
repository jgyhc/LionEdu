//
//  BLMealContentTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/13.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMealContentTableViewCell.h"

@interface BLMealContentTableViewCell ()



@end

@implementation BLMealContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NSString *)model {
    self.contenLabel.text = model;
}

@end
