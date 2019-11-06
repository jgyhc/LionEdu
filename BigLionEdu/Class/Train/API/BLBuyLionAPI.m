//
//  BLBuyLionAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLBuyLionAPI.h"

@implementation BLBuyLionAPI

- (NSString *)methodName {
    return @"appShoppingMall/buyLion";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
