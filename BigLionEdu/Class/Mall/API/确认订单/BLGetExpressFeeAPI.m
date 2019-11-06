//
//  BLGetExpressFeeAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/21.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetExpressFeeAPI.h"

@implementation BLGetExpressFeeAPI

- (NSString *)methodName {
    return @"appShoppingMall/getExpressFee";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
