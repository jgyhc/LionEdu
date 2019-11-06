//
//  BLGetTestPaperQuestionAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGetTestPaperQuestionAPI.h"

@implementation BLGetTestPaperQuestionAPI

- (NSString *)methodName {
    return @"appItemBank/getTestPaperQuestion";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}
@end
