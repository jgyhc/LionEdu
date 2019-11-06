//
//  BLGetGoodsDetailAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetGoodsDetailAPI.h"

@implementation BLGetGoodsDetailAPI

- (NSString *)methodName {
    return @"appShoppingMall/getGoodsDetail";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
