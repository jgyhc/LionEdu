
//
//  BLGetFunctionTypeAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/7.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetFunctionTypeAPI.h"

@implementation BLGetFunctionTypeAPI

//GET /kylin/sys/app/appModuleType/getFunctionType
- (NSString *)methodName {
    return @"appModuleType/getFunctionType";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end
