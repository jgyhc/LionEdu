//
//  BLNewsListModel.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/3.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLNewsListModel.h"

@implementation BLNewsListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [BLNewsDTOListModel class]};
}
@end
