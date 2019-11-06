//
//  BLGetConfirmCouponAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/21.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetConfirmCouponAPI.h"

@implementation BLGetConfirmCouponAPI

- (NSString *)methodName {
    return @"appShoppingMall/getConfirmCoupon";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}


@end
