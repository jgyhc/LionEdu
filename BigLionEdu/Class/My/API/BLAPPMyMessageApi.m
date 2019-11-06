//
//  BLAPPMyMessageApi.m
//  BigLionEdu
//
//  Created by sunmaomao on 2019/9/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyMessageApi.h"

@implementation BLAPPMyMessageTypeApi
- (NSString *)methodName {
    return @"appMyself/getMessateType";
    
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end

@implementation BLAPPMyMessageApi
- (NSString *)methodName {
    return @"appMyself/getMessageList";
    
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
