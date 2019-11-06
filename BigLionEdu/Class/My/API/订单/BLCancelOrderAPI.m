//
//  BLCancelOrderAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/13.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLCancelOrderAPI.h"

@implementation BLCancelOrderAPI

- (NSString *)methodName {
    return @"appShoppingMall/cancelOrder";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}



@end
