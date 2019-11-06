//
//  BLGetSetSearchAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetSetSearchAPI.h"

@implementation BLGetSetSearchAPI

- (NSString *)methodName {
    return @"appItemBank/getSetSearch";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end
