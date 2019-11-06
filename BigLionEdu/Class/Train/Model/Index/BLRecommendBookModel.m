//
//  BLRecommendBookModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLRecommendBookModel.h"

@implementation BLRecommendBookModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"kylinCoreDoodsList" : [BLTrainCoreDoodsListModel class]
             };
}
@end
