//
//  BLSearchHistoryDeleteAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLSearchHistoryDeleteAPI.h"

@implementation BLSearchHistoryDeleteAPI

- (NSString *)methodName {
    return @"appShoppingMall/deleteHistory";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeDelete;
}

@end
