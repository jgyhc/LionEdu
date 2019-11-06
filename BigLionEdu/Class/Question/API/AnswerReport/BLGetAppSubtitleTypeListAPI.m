//
//  BLGetAppSubtitleTypeListAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetAppSubtitleTypeListAPI.h"

@implementation BLGetAppSubtitleTypeListAPI

- (NSString *)methodName {
    return @"appSubtitle/getAppSubtitleTypeList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
