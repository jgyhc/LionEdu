//
//  NSMutableAttributedString+BLTextBorder.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "NSMutableAttributedString+BLTextBorder.h"

@implementation NSMutableAttributedString (BLTextBorder)

+ (NSMutableAttributedString *)initText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor cornerRadius:(CGFloat)cornerRadius strokeWidth:(CGFloat)strokeWidth {
    return [self initText:text textColor:textColor font:font strokeColor:strokeColor fillColor:fillColor cornerRadius:cornerRadius strokeWidth:strokeWidth insets:UIEdgeInsetsMake(-2, -5.5, -2, -8)];
}

+ (NSMutableAttributedString *)initText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor cornerRadius:(CGFloat)cornerRadius strokeWidth:(CGFloat)strokeWidth insets:(UIEdgeInsets)insets {
    NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:text];
    [tagText yy_insertString:@"   " atIndex:0];
    [tagText yy_appendString:@"   "];
    tagText.yy_font = font;
    tagText.yy_color = textColor;
    [tagText yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.yy_rangeOfAll];
    
    YYTextBorder *border = [YYTextBorder new];
    border.strokeWidth = strokeWidth;
    border.strokeColor = strokeColor;
    border.fillColor = fillColor;
    border.cornerRadius = cornerRadius; // a huge value
    border.lineJoin = kCGLineJoinBevel;
    
    border.insets = insets;
    [tagText yy_setTextBackgroundBorder:border range:[tagText.string rangeOfString:text]];
    return tagText;
}


@end
