//
//  BLOrderInfoAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/13.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLOrderInfoAPI.h"

@implementation BLOrderInfoAPI

- (NSString *)methodName {
    return @"appShoppingMall/orderInfo";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}


@end
