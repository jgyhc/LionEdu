//
//  BLAPPMyRecordApi.m
//  BigLionEdu
//
//  Created by mac on 2019/9/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyRecordApi.h"

@implementation BLAPPMyRecordTypeApi
- (NSString *)methodName {
    return @"appMyself/getAppMyQuestionRecordType";
    
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end

@implementation BLAPPMyRecordInfoApi
- (NSString *)methodName {
    return @"appMyself/getAppMyQuestionRecordInfo";
    
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
