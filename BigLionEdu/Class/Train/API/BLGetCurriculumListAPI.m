//
//  BLGetCurriculumListAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGetCurriculumListAPI.h"

@implementation BLGetCurriculumListAPI

#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appCurriculum/getCurriculumList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end
