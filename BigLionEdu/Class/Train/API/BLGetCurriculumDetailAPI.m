//
//  BLGetCurriculumDetailAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetCurriculumDetailAPI.h"

@implementation BLGetCurriculumDetailAPI

- (NSString *)methodName {
    return @"appCurriculum/getCurriculumDetail";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
