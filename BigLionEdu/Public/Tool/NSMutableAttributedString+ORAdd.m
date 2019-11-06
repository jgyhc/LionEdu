//
//  NSMutableAttributedString+ORAdd.m
//  NTStartget
//
//  Created by 欧阳荣 on 2018/6/1.
//  Copyright © 2018 NineTonTech. All rights reserved.
//

#import "NSMutableAttributedString+ORAdd.h"

@implementation NSMutableAttributedString (ORAdd)

- (void)or_addAttributesForNumbers:(nonnull NSDictionary<NSAttributedStringKey,id> *)attributes {
    
    
    NSRange range = [self.string rangeOfString:@"\\d+" options:NSRegularExpressionSearch];
    
    NSRange subRange = NSMakeRange(range.location, range.length);
    
    NSMutableString *subStr = self.string.mutableCopy;
    
    while (subRange.location != NSNotFound) {
        
        NSString *rangeStr = [self.string substringWithRange:range];
        [self addAttributes:attributes range:range];

        [subStr deleteCharactersInRange:NSMakeRange(0, subRange.location + subRange.length)];
        subRange = [subStr rangeOfString:@"\\d+" options:NSRegularExpressionSearch];
        
        range = NSMakeRange(range.location + subRange.location + rangeStr.length, subRange.length);
    }
}

@end
