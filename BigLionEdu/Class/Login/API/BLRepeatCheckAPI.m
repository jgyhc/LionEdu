//
//  BLRepeatCheckAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/24.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLRepeatCheckAPI.h"

@implementation BLRepeatCheckAPI
- (NSString *)methodName {
    return @"appLoginRegister/repeatCheck";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
