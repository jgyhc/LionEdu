//
//  BLGetAppTypeNewsAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/3.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetAppTypeNewsAPI.h"

@implementation BLGetAppTypeNewsAPI

- (NSString *)methodName {
    return @"appNews/getAppTypeNews";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
