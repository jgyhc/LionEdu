//
//  BLGoodsSureModel.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/21.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BLGoodsModel.h"

@class BLGoodsSureModel,BLGoodsSureCouponModel;
NS_ASSUME_NONNULL_BEGIN
//
//{
//    "id": 4,
//    "modelId": 12,
//    "memberId": null,
//    "title": "大师讲课解析",
//    "price": 90,
//    "coverImg": null,
//    "salesNum": null,
//    "isRecommend": null,
//    "discountTypePick": null,
//    "type": "2",
//    "typeId": 3,
//    "labelId": 2,
//    "labelName": "拼团"
//},
@interface BLGoodsSureConfirmModel : NSObject

@property (nonatomic, strong) NSArray <BLGoodsSureModel *> *confirmGoodsList;
@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, copy) NSArray <BLGoodsSureCouponModel *>*couponList;

@property (nonatomic, strong) NSNumber *expressFee;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) BOOL isPaper;

//合计金额
@property (nonatomic, assign) CGFloat price;
//优惠金额
@property (nonatomic, assign) CGFloat discountPrice;

@property (nonatomic, assign) NSInteger buyNumber;

@end


@interface BLGoodsSureModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *coverImg;
@property (nonatomic, copy) NSString *salesNum;
@property (nonatomic, copy) NSString *isRecommend;
@property (nonatomic, copy) NSString *discountTypePick;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, copy) NSString *labelId;
@property (nonatomic, copy) NSString *labelName;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, assign) NSInteger goodsNum;
@property (nonatomic, copy) NSString *originPrice;

@end

/**
 * 计算运费（确认订单）
 */
@interface BLGoodsSureExpressModel : NSObject

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *remark;

@end

/**
title    string    优惠券名称
validDay    int    有效期
isDiscount    string    1：折扣券， 2：满减券 等等
couponType    string    优惠券类型0普通券 1 新人券 2 推荐人券
saleValue    string    折扣值或者满减优惠值
isLimited    string    是有限制金额要求 1是 0否
overPrice    Double    限制金额（条件）
isSingle    string    优惠券是否复用 1是 0否
instruction    string    使用说明
isCanUse    string    是否可用1是 0否
endDate    date    到期时间
 */
@interface BLGoodsSureCouponModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *validDay;
@property (nonatomic, copy) NSString *isDiscount;
@property (nonatomic, copy) NSString *couponType;
@property (nonatomic, copy) NSString *saleValue;
@property (nonatomic, copy) NSString *isLimited;
@property (nonatomic, copy) NSString *overPrice;
@property (nonatomic, copy) NSString *isSingle;
@property (nonatomic, assign) NSInteger isCanUse;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *instruction;
@property (nonatomic, assign) BOOL isSelected;

@end

/**
 * 小计多少件 xx元
 */
@interface BLGoodsSureBuyNumModel : NSObject

@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) NSInteger num;


@end

/**
 * 留言
 */
@interface BLGoodsSureMarkModel : NSObject

@property (nonatomic, copy) NSString *message;

@end

/**
 * 支付方式
 */
@interface BLGoodsSurePayWayModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) BOOL select;

@end



NS_ASSUME_NONNULL_END
