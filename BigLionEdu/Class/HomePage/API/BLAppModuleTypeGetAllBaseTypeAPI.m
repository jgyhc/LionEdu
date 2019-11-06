//
//  BLAppModuleTypeGetAllBaseTypeAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/15.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAppModuleTypeGetAllBaseTypeAPI.h"

@implementation BLAppModuleTypeGetAllBaseTypeAPI

#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appModuleType/getAllBaseType";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
