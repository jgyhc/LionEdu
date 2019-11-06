//  我的获取会员等级说明
//  BLAPPMyselfGetAppMemberGradeInfoAPI.m
//  BigLionEdu
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyselfGetAppMemberGradeInfoAPI.h"

@implementation BLAPPMyselfGetAppMemberGradeInfoAPI

#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/getAppMemberGradeInfo";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end
