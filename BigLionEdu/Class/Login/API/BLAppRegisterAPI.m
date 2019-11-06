//
//  BLAppRegisterAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAppRegisterAPI.h"

@implementation BLAppRegisterAPI


#pragma mark - CTAPIManager

- (NSString *)methodName {
    if (_urlParams) {
        __block NSString *paramsString = @"";
        NSArray *allKeys = [_urlParams allKeys];
        [allKeys enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            id value = [self.urlParams objectForKey:key];
            paramsString = [NSString stringWithFormat:@"%@=%@", key, value];
        }];
        return [NSString stringWithFormat:@"appLoginRegister/appRegister?%@", paramsString];
    }
    return @"appLoginRegister/appRegister";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePut;
}


@end
