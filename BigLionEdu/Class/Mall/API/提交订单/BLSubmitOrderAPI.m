//
//  BLSubmitOrderAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/13.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLSubmitOrderAPI.h"

@implementation BLSubmitOrderAPI

- (NSString *)methodName {
    return @"appShoppingMall/submitOrder";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}

- (BOOL)isShowProgressHUDWhenFailed {
    return NO;
}

- (BOOL)isHideProgressHUDWhenSuccess {
    return YES;
}

@end
