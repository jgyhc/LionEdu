//
//  BLInsertAddresAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLInsertAddresAPI.h"

@implementation BLInsertAddresAPI
#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/insertAddres";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePut;
}

- (BOOL)isHideProgressHUDWhenSuccess {
    return NO;
}

@end
