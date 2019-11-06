//
//  UITextField+BLCustomFont.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "UITextField+BLCustomFont.h"
#import <objc/runtime.h>
#import "NTCatergory.h"

@implementation UITextField (BLCustomFont)

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

- (void)setNoChange:(NSNumber *)noChange {
    [self nt_setAssociateValue:noChange withKey:@"f_noChange"];
    if ([noChange isEqualToNumber:@1]) {
        NSLog(@"===== %lf", self.font.pointSize);
        self.font = [UIFont systemFontOfSize:self.font.pointSize];
    }
}

- (NSNumber *)noChange {
    NSNumber *number = [self nt_getAssociatedValueForKey:@"f_noChange"];
    if (!number) {
        number = @0;
    }
    return number;
}


- (void)bl_awakeFromNib {
    [self bl_awakeFromNib];
    UIFont *font = [UIFont fontWithName:@"TsangerJinKai03-W03" size:self.font.pointSize];
    if (font) {
        self.font = font;
    }
}
//
//- (void)bl_awakeFromNib {
//    [self bl_awakeFromNib];
//    NSLog(@"%@", self.font.fontName);
//    if ([self.noChange isEqualToNumber:@1]) {
//        self.font = [UIFont systemFontOfSize:self.font.pointSize];
//    } else {
//        if ([self.font.fontName isEqualToString:@"PingFangSC-Regular"]) {
//            UIFont *font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:self.font.pointSize];
//            self.font = font;
//        } else {
//            UIFont *font = [UIFont fontWithName:@"TsangerJinKai03-W03" size:self.font.pointSize];
//            if (font) {
//                self.font = font;
//            }
//        }
//    }
//}

@end
