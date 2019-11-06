//
//  BLGetBaseCurriculumTypeAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGetBaseCurriculumTypeAPI.h"

@implementation BLGetBaseCurriculumTypeAPI
#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appModuleType/getBaseCurriculumType";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
