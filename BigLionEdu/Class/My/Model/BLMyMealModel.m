//
//  BLMyMealModel.m
//  BigLionEdu
//
//  Created by mac on 2019/9/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyMealModel.h"

@implementation BLMyAllMealModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid" : @"id",
             @"modelDescription" : @"description"};
}

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"description": @"modelDescription"};
//}

//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"createTime":@"TimeModel"};
//}
@end

@implementation BLMyMyMealModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid" : @"id",
             @"modelDescription" : @"description"};
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"createTime":@"TimeModel"};
}
@end


