//
//  BLGetGoodsTypeAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/7.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGetGoodsTypeAPI.h"

@implementation BLGetGoodsTypeAPI

- (NSString *)methodName {
    return @"appShoppingMall/getGoodsType";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
