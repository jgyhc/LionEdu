//
//  BLOrderModel.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLOrderModel.h"

@implementation BLOrderModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderGoodsList": [BLOrderGoodsModel class]};;
}

- (NSArray<BLOrderGoodsModel *> *)orderGoodsList {
    [_orderGoodsList enumerateObjectsUsingBlock:^(BLOrderGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.orderId) {
            obj.orderId = self.Id;
            obj.singleType = self.singleType;
        }
    }];
    return _orderGoodsList;
}

@end

@implementation BLOrderGoodsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @"id"};
}

- (void)setSingleType:(NSInteger)singleType {
    _singleType = singleType;
}

@end
