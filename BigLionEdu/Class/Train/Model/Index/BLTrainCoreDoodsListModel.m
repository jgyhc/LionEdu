//
//  BLTrainCoreDoodsListModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainCoreDoodsListModel.h"

@implementation BLTrainCoreDoodsListModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

- (void)setCoverImg:(NSString *)coverImg {
    _coverImg = [NSString stringWithFormat:@"%@%@", IMG_URL, coverImg?:@""];
}

@end
