//
//  BLUpdateMemberInfoAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLUpdateMemberInfoAPI.h"

@implementation BLUpdateMemberInfoAPI
#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/updateMemberInfo";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePut;
}

@end
