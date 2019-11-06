//
//  BLSubmissionAnswerAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/9/24.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLSubmissionAnswerAPI.h"

@implementation BLSubmissionAnswerAPI
- (NSString *)methodName {
    return @"appItemBank/submissionAnswer";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}
@end
