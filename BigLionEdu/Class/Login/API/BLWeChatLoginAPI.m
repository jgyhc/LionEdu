//
//  BLWeChatLoginAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/9/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLWeChatLoginAPI.h"

@implementation BLWeChatLoginAPI

- (NSString *)methodName {
    return @"appLoginRegister/weChatLogin";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
