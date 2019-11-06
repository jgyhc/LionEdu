//
//  BLGetGoodsListAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/7.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGetGoodsListAPI.h"

@implementation BLGetGoodsListAPI

- (NSString *)methodName {
    return @"appShoppingMall/getGoods";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
