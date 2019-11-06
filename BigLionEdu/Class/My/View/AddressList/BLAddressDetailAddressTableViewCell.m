//
//  BLAddressDetailAddressTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAddressDetailAddressTableViewCell.h"
#import "UITextView+PlaceHolder.h"
#import <UIControl+BlocksKit.h>

@interface BLAddressDetailAddressTableViewCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation BLAddressDetailAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _textView.text = @"";
    _textView.placeholder = @"详细地址（精确到门牌号）";
    _textView.delegate = self;
    _textView.placeholderLabel.font = [UIFont fontWithName:@"TsangerJinKai03-W03" size:15];
    _textView.placeholderColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0];
    
}

#pragma mark --  UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.model.detail = textView.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLAddressModel *)model {
    _model = model;
    _textView.text = model.detail;
    if (model.detail.length) {
        self.textView.placeholder = @"";
    } else {
        self.textView.placeholder = @"详细地址（精确到门牌号）";
    }
}


@end
