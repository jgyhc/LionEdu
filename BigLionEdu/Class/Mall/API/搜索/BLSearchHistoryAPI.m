//
//  BLSearchHistoryAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLSearchHistoryAPI.h"

@implementation BLSearchHistoryAPI

- (NSString *)methodName {
    return @"appShoppingMall/getSearchHistory";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

- (BOOL)isShowProgressHUDWhenFailed {
    return NO;
}


@end
