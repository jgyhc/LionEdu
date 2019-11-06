//
//  BLAppItemBankGetQuestionsListAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/15.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAppItemBankGetQuestionsListAPI.h"

@implementation BLAppItemBankGetQuestionsListAPI


- (NSString *)methodName {
    return @"appItemBank/getQuestionsList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}


@end
