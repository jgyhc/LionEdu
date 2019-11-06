//
//  BLCartModel.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLCartModel.h"

@implementation BLCartModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @"id"};
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
}

- (void)setGoodsNum:(NSInteger)goodsNum {
    _goodsNum = goodsNum;
}

@end
