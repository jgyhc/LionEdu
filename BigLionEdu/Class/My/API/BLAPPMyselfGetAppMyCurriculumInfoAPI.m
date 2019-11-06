//  我的根据会员id获取我的课程
//  BLAPPMyselfGetAppMyCurriculumInfoAPI.m
//  BigLionEdu
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyselfGetAppMyCurriculumInfoAPI.h"

@implementation BLAPPMyselfGetAppMyCurriculumInfoAPI

#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/getAppMyCurriculumInfo";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
