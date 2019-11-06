//
//  BLGetAllAreaAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/17.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetAllAreaAPI.h"

@implementation BLGetAllAreaAPI


#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appModuleType/getAllArea";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
