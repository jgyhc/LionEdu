//
//  BLMyInterestItemModel.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyInterestItemModel.h"

@implementation BLMyInterestItemModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"baseModels": [BLInterestInfoModel class],@"myModels": [BLInterestInfoModel class]};
}
@end


@implementation BLInterestInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}
@end
