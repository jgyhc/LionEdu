//
//  BLGetDailyTipOrQuestionAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/9/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGetDailyTipOrQuestionAPI.h"

@implementation BLGetDailyTipOrQuestionAPI

- (NSString *)methodName {
    return @"appItemBank/getDailyTipOrQuestion";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end
