//
//  BLContactUSAPI.m
//  BigLionEdu
//
//  Created by OrangesAL on 2019/10/13.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLContactUSAPI.h"

@implementation BLContactUSAPI

- (NSString *)methodName {
    return @"appMyself/getCallList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}



@end
