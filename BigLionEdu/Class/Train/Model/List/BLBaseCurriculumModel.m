//
//  BLBaseCurriculumModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLBaseCurriculumModel.h"

@implementation BLBaseCurriculumModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"functionTypeDTOList" : [BLBaseCurriculumModel class]};
}

@end
