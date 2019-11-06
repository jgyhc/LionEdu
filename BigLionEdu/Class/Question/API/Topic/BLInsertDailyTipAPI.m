//
//  BLInsertDailyTipAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/25.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLInsertDailyTipAPI.h"

@implementation BLInsertDailyTipAPI

- (NSString *)methodName {
    return @"appItemBank/insertDailyTip";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}

@end
