//
//  BLReturnPayAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/7.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLReturnPayAPI.h"

@implementation BLReturnPayAPI

- (NSString *)methodName {
    return @"appShoppingMall/returnPay";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
