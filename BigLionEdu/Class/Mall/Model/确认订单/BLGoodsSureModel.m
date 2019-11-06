//
//  BLGoodsSureModel.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/21.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGoodsSureModel.h"

@implementation BLGoodsSureConfirmModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"confirmGoodsList": [BLGoodsSureModel class],
             @"couponList": [BLGoodsSureCouponModel class]
    };
}

- (void)setMessage:(NSString *)message {
    _message = message;
}

- (CGFloat)price {
    CGFloat p = 0.0;
    _discountPrice = 0.0;
    //商品价格
    for (NSInteger i = 0; i < self.confirmGoodsList.count; i ++) {
        BLGoodsSureModel *obj = self.confirmGoodsList[i];
        p += obj.price.floatValue * obj.goodsNum;
    }
    //邮费
    p += self.expressFee.floatValue;
    //优惠
    for (NSInteger i = 0; i < self.couponList.count; i ++) {
        BLGoodsSureCouponModel *obj = self.couponList[i];
        if (obj.isSelected) {
            p -= obj.saleValue.floatValue;
            _discountPrice += obj.saleValue.floatValue;
        }
    }
    return p;
}

- (NSInteger)buyNumber {
    NSInteger p = 0.0;
    for (NSInteger i = 0; i < self.confirmGoodsList.count; i ++) {
        BLGoodsSureModel *obj = self.confirmGoodsList[i];
        p += obj.goodsNum;
    }
    return p;
}

@end

@implementation BLGoodsSureModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @"id"};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _goodsNum = 1;
    }
    return self;
}

- (void)setGoodsNum:(NSInteger)goodsNum {
    _goodsNum = goodsNum;
}

@end

@implementation BLGoodsSureExpressModel

@end

@implementation BLGoodsSureCouponModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @"id"};
}

@end

@implementation BLGoodsSureBuyNumModel

- (void)setNum:(NSInteger)num {
    _num = num;
}

- (void)setPrice:(NSString *)price {
    _price = price;
}

@end

/**
 * 留言
 */
@implementation BLGoodsSureMarkModel

- (void)setMessage:(NSString *)message {
    _message = message;
}

@end

/**
 * 支付方式
 */
@implementation BLGoodsSurePayWayModel


@end
