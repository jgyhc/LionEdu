//
//  BLSetModuleAPI.m
//  BigLionEdu
//
//  Created by OrangesAL on 2019/10/8.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLSetModuleAPI.h"

@implementation BLSetModuleHelpAPI

- (NSString *)methodName {
    return @"appMyself/getHelpInfo";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end

@implementation BLSetModuleFeedBackAPI

- (NSString *)methodName {
    return @"appMyself/insertFeedback";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePut;
}

@end

