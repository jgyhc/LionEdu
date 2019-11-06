//
//  BLOrderSureQuantityTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderSureQuantityTableViewCell.h"

@implementation BLOrderSureQuantityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.numView.quantityLabel.text = @"1";
    __weak typeof(self) wself = self;
    [self.numView setOrderSureNumberViewHandler:^(NSInteger num) {
        self.model.goodsNum = num;
        [wself.delegate buyNumberDidChange:num];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(BLGoodsSureModel *)model {
    _model = model;
    self.numView.quantityLabel.text = [NSString stringWithFormat:@"%ld", (long)model.goodsNum];
    if (self.model.type == 0) {
        self.numView.userInteractionEnabled = YES;
    } else {
        self.numView.userInteractionEnabled = NO;
    }
}

@end
