//
//  BLGetAppNewsByIdAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/3.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetAppNewsByIdAPI.h"

@implementation BLGetAppNewsByIdAPI

- (NSString *)methodName {
    return @"appNews/getAppNewsById";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
