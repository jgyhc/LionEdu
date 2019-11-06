//
//  BLScreeningItemModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/18.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLScreeningItemModel.h"


@implementation BLScreeningItemModel

- (void)setTitle:(NSString *)title {
    _title = title;
    _textWidth = [self getWidthWithText:title height:20 font:14];
}

- (CGFloat)getWidthWithText:(NSString*)text height:(CGFloat)height font:(CGFloat)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width;
}

@end
