//
//  BLGetLabelListAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetLabelListAPI.h"

@implementation BLGetLabelListAPI

- (NSString *)methodName {
    return @"appShoppingMall/getLabelList";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
