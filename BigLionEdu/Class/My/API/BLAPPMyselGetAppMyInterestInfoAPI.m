//  根据会员id获取我的兴趣
//  BLAPPMyselGetAppMyInterestInfoAPI.m
//  BigLionEdu
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyselGetAppMyInterestInfoAPI.h"

@implementation BLAPPMyselGetAppMyInterestInfoAPI

#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/getAppMyInterestInfo";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end


@implementation BLAPPMyselInsertMyInterestInfoAPI
- (NSString *)methodName {
    return @"appMyself/insertMyInterest";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePut;
}
@end
