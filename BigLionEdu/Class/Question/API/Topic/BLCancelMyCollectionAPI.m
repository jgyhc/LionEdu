//
//  BLCancelMyCollectionAPI.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/24.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLCancelMyCollectionAPI.h"

@implementation BLCancelMyCollectionAPI
- (NSString *)methodName {
    return @"appMyself/cancelMyCollection";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeDelete;
}

- (BOOL)isShowProgressHUD {
    return NO;
}
@end
