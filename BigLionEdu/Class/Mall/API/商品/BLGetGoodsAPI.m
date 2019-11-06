//
//  BLGetGoodsAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/6.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetGoodsAPI.h"

@implementation BLGetGoodsAPI

- (NSString *)methodName {
    return @"appShoppingMall/getGoods";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}


@end
