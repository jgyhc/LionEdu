//  获取优惠券列表 （待使用）
//  BLAPPMyselfGetMemberCouponListAPI.m
//  BigLionEdu
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyselfGetMemberCouponListAPI.h"

@implementation BLAPPMyselfGetMemberCouponListAPI

#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/getMemberCouponList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end
