//
//  BLUpdateAddresAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLUpdateAddresAPI.h"

@implementation BLUpdateAddresAPI

#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/updateAddres";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePut;
}

- (BOOL)isHideProgressHUDWhenSuccess {
    return NO;
}
@end
