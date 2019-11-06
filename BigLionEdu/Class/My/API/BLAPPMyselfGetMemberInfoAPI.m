//  获取用户信息
//  BLAPPMyselfGetMemberInfoAPI.m
//  BigLionEdu
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyselfGetMemberInfoAPI.h"

@implementation BLAPPMyselfGetMemberInfoAPI

#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/getMemberInfo";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end
