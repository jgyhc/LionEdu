//
//  BLCreateGroupAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLCreateGroupAPI.h"

@implementation BLCreateGroupAPI

- (NSString *)methodName {
    return @"appShoppingMall/createGroup";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
