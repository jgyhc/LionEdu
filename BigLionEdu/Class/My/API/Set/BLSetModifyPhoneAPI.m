//
//  BLSetModifyPhoneAPI.m
//  BigLionEdu
//
//  Created by OrangesAL on 2019/10/8.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLSetModifyPhoneAPI.h"

@implementation BLSetModifyPhoneAPI

- (NSString *)methodName {
    return @"appLoginRegister/updateMobile";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}


@end

@implementation BLSetcheckPasswordAPI

- (NSString *)methodName {
    return @"appLoginRegister/checkPassword";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}


@end

