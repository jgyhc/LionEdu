//
//  BLGetQuestionListAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/9/19.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetQuestionListAPI.h"

@implementation BLGetQuestionListAPI
- (NSString *)methodName {
    return @"appItemBank/getQuestionList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
