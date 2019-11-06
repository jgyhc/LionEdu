//
//  AlipayManager.h
//  ManJi
//
//  Created by Zgmanhui on 16/7/8.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Product;
@interface AlipayManager : NSObject


+(instancetype)sharedManager;
+ (void)goZhiFuBao:(Product *)product ;

/**
 *  @author Zgmanhui, 16-08-03 15:08:28
 *
 *  签名后的方法
 *
 *  @param orderString 订单信息
 */
- (void)zhifubaoPay:(NSString *)orderString resultBlock:(void(^)(NSDictionary *resultDic))result;

@property (nonatomic, copy) void (^AlipayManagerBlock)(NSDictionary *resultDic);

@end
//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;



@end
