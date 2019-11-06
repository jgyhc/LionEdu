//
//  BLMessageListTableViewCell.m
//  BigLionEdu
//
//  Created by sunmaomao on 2019/9/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMessageListTableViewCell.h"

@implementation BLMessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(BLMyNewsModel *)model{
    self.titLab.text = model.title;
    self.desLab.text = model.content;
//    self.timeLab.text = model
}

@end
