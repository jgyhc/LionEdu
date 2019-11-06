//
//  BLDeleteAddresAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLDeleteAddresAPI.h"

@implementation BLDeleteAddresAPI

- (NSString *)methodName {
    return @"appMyself/deleteAddres";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeDelete;
}

@end
