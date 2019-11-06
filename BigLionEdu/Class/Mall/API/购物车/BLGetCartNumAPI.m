
//
//  BLGetCartNumAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetCartNumAPI.h"

@implementation BLGetCartNumAPI

- (NSString *)methodName {
    return @"appShoppingMall/getGoodsCartSize";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUDWhenFailed {
    return NO;
}

@end
