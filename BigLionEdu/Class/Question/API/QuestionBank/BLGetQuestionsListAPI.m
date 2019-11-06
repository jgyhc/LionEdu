//
//  BLGetQuestionsListAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/25.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGetQuestionsListAPI.h"

@implementation BLGetQuestionsListAPI
#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appItemBank/getQuestionsList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}
@end
