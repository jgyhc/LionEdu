//
//  BLGetAddressListAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGetAddressListAPI.h"

@implementation BLGetAddressListAPI

#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/getAddressList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end
