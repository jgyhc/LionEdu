//
//  BLAppAccompanyGetAppAccompanyInfoAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAppAccompanyGetAppAccompanyInfoAPI.h"

@implementation BLAppAccompanyGetAppAccompanyInfoAPI
#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appAccompany/getAppAccompanyInfo";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
