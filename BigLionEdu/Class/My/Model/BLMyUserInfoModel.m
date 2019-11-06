//
//  BLMyUserInfoModel.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyUserInfoModel.h"

@implementation BLMyUserInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"modelid"]};
}

@end
