//
//  BLDeleteOrderAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/13.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLDeleteOrderAPI.h"

@implementation BLDeleteOrderAPI

- (NSString *)methodName {
    return @"appShoppingMall/deleteOrder";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeDelete;
}

@end
