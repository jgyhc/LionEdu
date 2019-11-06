//
//  BLCartListAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLCartListAPI.h"

@implementation BLCartListAPI

- (NSString *)methodName {
    return @"appShoppingMall/getGoodsCartList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end

