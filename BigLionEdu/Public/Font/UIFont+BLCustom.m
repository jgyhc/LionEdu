//
//  UIFont+BLCustom.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "UIFont+BLCustom.h"
#import <objc/runtime.h>
#import "NTCatergory.h"

@implementation UIFont (BLCustom)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        Method orignalMethod = class_getClassMethod(class, @selector(systemFontOfSize:));

        Method myMethod = class_getClassMethod(class, @selector(bl_systemFontOfSize:));
    
        method_exchangeImplementations(orignalMethod, myMethod);
        

        Method orignalMethod1 = class_getClassMethod(class, @selector(boldSystemFontOfSize:));

        Method myMethod1 = class_getClassMethod(class, @selector(bl_boldSystemFontOfSize:));

        method_exchangeImplementations(orignalMethod1, myMethod1);
    });
}

+ (UIFont *)bl_systemFontOfSize:(CGFloat)fontSize
{
    UIFont * font = [UIFont fontWithName:@"TsangerJinKai03-W03" size:fontSize];
    if (!font) {
        return [self bl_systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)bl_boldSystemFontOfSize:(CGFloat)fontSize
{
    UIFont * font = [UIFont fontWithName:@"TsangerJinKai03-W04" size:fontSize];
    if (!font) {
        return [self bl_boldSystemFontOfSize:fontSize];
    }
    return font;
}

//
//+ (UIFont *)bl_italicSystemFontOfSize:(CGFloat)fontSize
//{
//    UIFont * font = [UIFont fontWithName:@"TsangerJinKai03-W03" size:fontSize];
//    if (!font) {
//        return [self bl_italicSystemFontOfSize:fontSize];
//    }
//    return font;
//}



@end
