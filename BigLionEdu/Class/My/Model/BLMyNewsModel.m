//
//  BLMyNewsModel.m
//  BigLionEdu
//
//  Created by sunmaomao on 2019/9/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyNewsModel.h"

@implementation BLMyNewsModel

@end


@implementation BLMyNewsTypeModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"],@"customDescription":@[@"description",@"customDescription"]};
}
@end
