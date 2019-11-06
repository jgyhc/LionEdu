//
//  ZLFactory.m
//  ZhenLearnDriving_Coach
//
//  Created by OrangesAL on 2019/3/31.
//  Copyright © 2019年 刘聪. All rights reserved.
//

#import "ZLFactory.h"

@implementation ZLFactory

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = textColor;
    return label;
}

+ (UITextField *)textFieldWithFont:(UIFont *)font textColor:(UIColor *)textColor leftSpace:(CGFloat)leftSpace {
    
    UITextField *textField = [UITextField new];
    textField.font = font;
    textField.textColor = textColor;
    if (leftSpace > 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftSpace, 0)];
        textField.leftView = view;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return textField;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)textColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return btn;
}

@end
