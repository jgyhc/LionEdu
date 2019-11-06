//
//  BLMealFailureTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/13.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMealFailureTableViewCell.h"

@implementation BLMealFailureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(BLMyMyMealModel *)model{
    self.titLab.text = model.name;
    self.moneyLab.text = [NSString stringWithFormat:@"￥%0.2ld/%li个月",(long)model.price,(long)model.dueTime];
    self.buyTimeLab.text = model.createTimeStr;
    self.endTimeLab.text = model.endDateStr;
}

@end
