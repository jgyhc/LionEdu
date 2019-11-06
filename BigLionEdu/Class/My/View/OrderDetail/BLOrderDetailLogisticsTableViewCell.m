//
//  BLOrderDetailLogisticsTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderDetailLogisticsTableViewCell.h"

@implementation BLOrderDetailLogisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(BLOrderModel *)model {
    _model = model;
    self.orderNo.text = [NSString stringWithFormat:@"%@  %@",  model.company,model.expressNum];
}

@end
