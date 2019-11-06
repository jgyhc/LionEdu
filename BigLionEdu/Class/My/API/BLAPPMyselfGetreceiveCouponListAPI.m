//  可领取优惠券列表
//  BLAPPMyselfGetreceiveCouponListAPI.m
//  BigLionEdu
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyselfGetreceiveCouponListAPI.h"

@implementation BLAPPMyselfGetreceiveCouponListAPI
#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/getReceiveCouponList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end


@implementation BLAPPMyselfReceiveCouponAPI
- (NSString *)methodName {
    return @"appMyself/receiveCoupon";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end


@implementation BLAPPMyselfExchangeCouponAPI
- (NSString *)methodName {
    return @"appMyself/exchangeCoupon";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
