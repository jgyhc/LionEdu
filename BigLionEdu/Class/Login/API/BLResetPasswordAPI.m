//
//  BLResetPasswordAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/24.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLResetPasswordAPI.h"

@implementation BLResetPasswordAPI
- (NSString *)methodName {
    return @"appLoginRegister/resetPassword";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
