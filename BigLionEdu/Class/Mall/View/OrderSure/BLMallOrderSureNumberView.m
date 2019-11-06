//
//  BLMallOrderSureNumberView.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMallOrderSureNumberView.h"
#import <Masonry.h>

@interface BLMallOrderSureNumberView ()



@end

@implementation BLMallOrderSureNumberView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
    self.layer.borderWidth = 1;
    [self addSubview:self.addButton];
    [self addSubview:self.reduceButton];
    [self addSubview:self.quantityLabel];
    
    [self.reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(22);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(22);
    }];
    
    [self.quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(0);
        make.bottom.mas_equalTo(self).mas_offset(0);
        make.left.mas_equalTo(self.reduceButton.mas_right);
        make.right.mas_equalTo(self.addButton.mas_left);
    }];
    
}


- (void)addEvent:(id)sender {
    NSInteger num = self.quantityLabel.text.integerValue;
    num += 1;
    self.quantityLabel.text = [NSString stringWithFormat:@"%ld", num];
    !self.orderSureNumberViewHandler?:self.orderSureNumberViewHandler(num);
}

- (void)reduceEvent:(id)sender {
    NSInteger num = self.quantityLabel.text.integerValue;
    num -= 1;
    if (num <= 0) {
        return;
    }
    self.quantityLabel.text = [NSString stringWithFormat:@"%ld", num];
    !self.orderSureNumberViewHandler?:self.orderSureNumberViewHandler(num);
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"+" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _addButton;
}

- (UIButton *)reduceButton {
    if (!_reduceButton) {
        _reduceButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"-" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button addTarget:self action:@selector(reduceEvent:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _reduceButton;
}

- (UITextField *)quantityLabel {
    if (!_quantityLabel) {
        _quantityLabel = ({
            UITextField *label = [[UITextField alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            label.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
            label.layer.borderWidth = 1;
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _quantityLabel;
}

@end
