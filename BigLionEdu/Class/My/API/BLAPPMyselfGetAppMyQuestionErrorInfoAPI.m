//  错本题
//  BLAPPMyselfGetAppMyQuestionErrorInfoAPI.m
//  BigLionEdu
//
//  Created by mac on 2019/8/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyselfGetAppMyQuestionErrorInfoAPI.h"

@implementation BLAPPMyselfGetAppMyQuestionErrorTypeAPI

- (NSString *)methodName {
    return @"appItemBank/getQuestionErrorSum";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end

@implementation BLAPPMyselfGetAppMyQuestionErrorInfoAPI
#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/getAppMyQuestionErrorTypeLowerInfo";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end

@implementation BLAPPMyselfDeleteMyQuestionErrorInfoAPI
#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/deleteMyQuestionError";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeDelete;
}
@end



