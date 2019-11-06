//
//  BLMyCouponsItemModel.m
//  BigLionEdu
//
//  Created by mac on 2019/8/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyCouponsItemModel.h"

@implementation BLMyCouponsItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list":@"BLMyCouponslistModel"};
}


@end

@implementation BLMyCouponslistModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}

@end
