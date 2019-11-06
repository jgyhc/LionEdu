//
//  BLTopicFontManager.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/16.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTopicFontManager.h"


@implementation BLTopicFontManager

+ (instancetype)sharedInstance {
    static BLTopicFontManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BLTopicFontManager alloc] init];
    });
    return manager;
}

- (void)setFontSizeType:(NSInteger)fontSizeType {
    if (_fontSizeType != fontSizeType) {
        _fontSizeType = fontSizeType;
        _titleFont = nil;
        _contentFont = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BLTopicFontDidChange" object:nil userInfo:nil];
    }
}

- (UIFont *)titleFont {
    CGFloat size = 15;
    switch (_fontSizeType) {
        case -1:
            size = 13;
            break;
        case 0:
            size = 15;
        break;
        case 1:
            size = 17;
        break;
        default:
        break;
    }
    return [UIFont systemFontOfSize:size];
}

- (UIFont *)contentFont {
    CGFloat size = 14;
    switch (_fontSizeType) {
        case -1:
            size = 12;
            break;
        case 0:
            size = 14;
        break;
        case 1:
            size = 16;
        break;
        default:
            break;
    }
    return [UIFont systemFontOfSize:size];
}

- (void)setCurrentTopicCount:(NSInteger)currentTopicCount {
    _currentTopicCount = currentTopicCount;
}

@end
