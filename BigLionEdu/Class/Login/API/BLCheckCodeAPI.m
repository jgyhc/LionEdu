//
//  BLCheckCodeAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLCheckCodeAPI.h"

@implementation BLCheckCodeAPI


#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appLoginRegister/checkCode";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
