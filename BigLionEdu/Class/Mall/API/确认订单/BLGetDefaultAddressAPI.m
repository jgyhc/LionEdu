//
//  BLGetAddressListAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/21.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetDefaultAddressAPI.h"

@implementation BLGetDefaultAddressAPI

- (NSString *)methodName {
    return @"appMyself/getDefaultAddress";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}



@end
