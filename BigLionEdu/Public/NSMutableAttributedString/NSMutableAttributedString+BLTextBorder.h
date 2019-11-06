//
//  NSMutableAttributedString+BLTextBorder.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYText.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (BLTextBorder)

+ (NSMutableAttributedString *)initText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor cornerRadius:(CGFloat)cornerRadius strokeWidth:(CGFloat)strokeWidth;


+ (NSMutableAttributedString *)initText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor cornerRadius:(CGFloat)cornerRadius strokeWidth:(CGFloat)strokeWidth insets:(UIEdgeInsets)insets;
@end

NS_ASSUME_NONNULL_END
