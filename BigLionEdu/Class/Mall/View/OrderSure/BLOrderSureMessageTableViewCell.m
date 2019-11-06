//
//  BLOrderSureMessageTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderSureMessageTableViewCell.h"
#import "NTCatergory.h"

@implementation BLOrderSureMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    __weak typeof(self) wself = self;
    [self.textFiled nt_addConfig:^(__kindof UITextField * _Nonnull control) {
        wself.model.message = control.text;
    } forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLGoodsSureConfirmModel *)model {
    _model = model;
    self.textFiled.text = model.message;
}

@end
