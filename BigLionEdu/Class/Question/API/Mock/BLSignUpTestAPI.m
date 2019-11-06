//
//  BLSignUpTestAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/28.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLSignUpTestAPI.h"

@implementation BLSignUpTestAPI

- (NSString *)methodName {
    return @"appItemBank/signUpTest";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}

@end
