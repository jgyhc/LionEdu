//
//  BLGetMySummaryAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/25.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetMySummaryAPI.h"

@implementation BLGetMySummaryAPI
- (NSString *)methodName {
    return @"appItemBank/getMySummary";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
