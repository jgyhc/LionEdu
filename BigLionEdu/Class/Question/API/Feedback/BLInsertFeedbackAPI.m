//
//  BLInsertFeedbackAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/13.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLInsertFeedbackAPI.h"

@implementation BLInsertFeedbackAPI
- (NSString *)methodName {
    return @"appMyself/insertFeedback";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePut;
}

@end
