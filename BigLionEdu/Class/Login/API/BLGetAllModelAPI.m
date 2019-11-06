//
//  BLGetAllModelAPI.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/9/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGetAllModelAPI.h"

@implementation BLGetAllModelAPI


- (NSString *)methodName {
    return @"appLoginRegister/getAllModel";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
