//
//  BLMyClassListModel.m
//  BigLionEdu
//
//  Created by mac on 2019/8/30.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyClassListModel.h"

@implementation BLMyClassListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"toturs": [BLMyClassTotursModel class]};
}
@end


@implementation BLMyClassTotursModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"id": @"modelid"};
}
@end
