//
//  BLAppLoginAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/24.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAppLoginAPI.h"

@implementation BLAppLoginAPI
#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appLoginRegister/appLogin";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}
@end
