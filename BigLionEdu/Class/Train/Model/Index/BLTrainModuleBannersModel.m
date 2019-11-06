//
//  BLTrainModuleBannersModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainModuleBannersModel.h"

@implementation BLTrainModuleBannersModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

- (void)setImg:(NSString *)img {
    _img = [NSString stringWithFormat:@"%@%@", IMG_URL, img?:@""];
}

@end
