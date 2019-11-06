//
//  BLCouponsFailureTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/29.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLCouponsFailureTableViewCell.h"

@implementation BLCouponsFailureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(BLMyCouponslistModel *)model{
    
    self.MoneyLab.text = model.saleValue;
    self.titLab.text = model.title;
    self.typeLab.text = model.isDiscount;
//    self.timeLab.text = model.validDay;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"有效期至：yyyy-MM-dd";
    NSDate *valiDate = [NSDate dateWithTimeIntervalSinceNow:model.validDay.integerValue * 24 * 60 * 60];
    self.timeLab.text = [formatter stringFromDate:valiDate];
    
    NSString *flag = model.status == 3 ? @"my_yhj_ygq" : @"my_wdyhq_ysy";
    self.flagImageView.image = [UIImage imageNamed:flag];
    
}


@end
