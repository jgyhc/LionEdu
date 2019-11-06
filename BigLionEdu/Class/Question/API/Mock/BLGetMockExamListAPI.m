//
//  BLGetMockExamListAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetMockExamListAPI.h"

@implementation BLGetMockExamListAPI

- (NSString *)methodName {
    return @"appItemBank/getMockExamList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}


@end
