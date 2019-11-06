//
//  BLQuestionAddCollectionAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/21.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLQuestionAddCollectionAPI.h"

@implementation BLQuestionAddCollectionAPI
- (NSString *)methodName {
    return @"appItemBank/addCollection";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}

- (BOOL)isHideProgressHUDWhenSuccess {
    return YES;
}

- (BOOL)isShowProgressHUD {
    return NO;
}
@end
