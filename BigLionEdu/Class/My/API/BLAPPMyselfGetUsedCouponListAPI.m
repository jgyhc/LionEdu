//  获取优惠券列表（已使用、已过期）
//  BLAPPMyselfGetUsedCouponListAPI.m
//  BigLionEdu
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyselfGetUsedCouponListAPI.h"

@implementation BLAPPMyselfGetUsedCouponListAPI
#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/getUsedCouponLsit";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
