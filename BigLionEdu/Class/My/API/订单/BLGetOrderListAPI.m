//
//  BLGetOrderListAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/13.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetOrderListAPI.h"

@implementation BLGetOrderListAPI


- (NSString *)methodName {
    return @"appShoppingMall/getOrderList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
