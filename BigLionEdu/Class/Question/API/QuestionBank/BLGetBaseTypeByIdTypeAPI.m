//
//  BLGetBaseTypeByIdTypeAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/30.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGetBaseTypeByIdTypeAPI.h"

@implementation BLGetBaseTypeByIdTypeAPI


- (NSString *)methodName {
    return @"appModuleType/getBaseTypeByIdType";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end
