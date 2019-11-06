//
//  BLBindingMobileAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/9/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLBindingMobileAPI.h"

@implementation BLBindingMobileAPI

- (NSString *)methodName {
    return @"appLoginRegister/bindingMobile";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePut;
}
@end
