//
//  BLGetAppNewsListAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetAppNewsListAPI.h"

@implementation BLGetAppNewsListAPI



- (NSString *)methodName {
    return @"appNews/getAppNewsList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}
@end
