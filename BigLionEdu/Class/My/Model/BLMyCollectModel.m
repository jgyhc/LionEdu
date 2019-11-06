//
//  BLMyCollectModel.m
//  BigLionEdu
//
//  Created by mac on 2019/9/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyCollectModel.h"
@implementation BLMyCollectTypeDotsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}
@end

@implementation BLMyCollectTypeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"functionTypeErrorDTOS": [BLMyCollectTypeDotsModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}
@end
