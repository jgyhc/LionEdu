//
//  BLAPPMyCollectApi.m
//  BigLionEdu
//
//  Created by mac on 2019/9/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyCollectApi.h"

@implementation BLAPPMyCollectTypeApi
- (NSString *)methodName {
    return @"appMyself/getAppMyQuestionCollectionType";
    
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
