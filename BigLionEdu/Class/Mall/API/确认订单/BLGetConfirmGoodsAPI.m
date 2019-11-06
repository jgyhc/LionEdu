//
//  BLGetConfirmGoodsAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/21.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetConfirmGoodsAPI.h"

@implementation BLGetConfirmGoodsAPI


- (NSString *)methodName {
    return @"appShoppingMall/getConfirmGoods";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}


@end
