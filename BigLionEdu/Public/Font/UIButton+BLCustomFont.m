//
//  UIButton+BLCustomFont.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "UIButton+BLCustomFont.h"
#import <objc/runtime.h>

@implementation UIButton (BLCustomFont)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //拿到系统方法
        SEL orignalSel3 = @selector(awakeFromNib);
        Method orignalM3 = class_getInstanceMethod(class, orignalSel3);
        SEL swizzledSel3 = @selector(bl_awakeFromNib);
        Method swizzledM3 = class_getInstanceMethod(class, swizzledSel3);
        BOOL didAddMethod3 = class_addMethod(class, orignalSel3, method_getImplementation(swizzledM3), method_getTypeEncoding(swizzledM3));
        if (didAddMethod3) {
            class_replaceMethod(class, swizzledSel3, method_getImplementation(orignalM3), method_getTypeEncoding(orignalM3));
        }else{
            method_exchangeImplementations(orignalM3, swizzledM3);
        }
        
    });
}

- (void)bl_awakeFromNib {
    [self bl_awakeFromNib];
    UIFont *font = [UIFont fontWithName:@"TsangerJinKai03-W03" size:self.titleLabel.font.pointSize];
    if (font) {
        self.titleLabel.font = font;
    }
}

@end
