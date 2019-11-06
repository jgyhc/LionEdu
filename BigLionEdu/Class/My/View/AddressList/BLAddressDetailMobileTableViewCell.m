//
//  BLAddressDetailMobileTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAddressDetailMobileTableViewCell.h"
#import <UIControl+BlocksKit.h>

@interface BLAddressDetailMobileTableViewCell ()

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation BLAddressDetailMobileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    __weak typeof(self) wself = self;
    [_textField bk_addEventHandler:^(UITextField * sender) {
        wself.model.mobile = sender.text;
    } forControlEvents:UIControlEventEditingChanged];
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号"attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0]}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLAddressModel *)model {
    _model = model;
    _textField.text = model.mobile;
}

@end
