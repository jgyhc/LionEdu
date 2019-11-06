//
//  BLOrderModel.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BLOrderGoodsModel;
NS_ASSUME_NONNULL_BEGIN

//"id": 1,
//"memberId": 2019001101,
//"addressId": 2,
//"orderCode": "82198516912",
//"dealPrice": 190,
//"status": "交易成功",
//"payMethod": "0",
//"expressId": "0",
//"expressNum": "259158365554",
//"expressFee": 0,
//"mobile": null,
//"name": null,
//"zipcode": null,
//"province": null,
//"city": null,
//"district": null,
//"detail": null,
@interface BLOrderModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *dealPrice;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *payMethod;
@property (nonatomic, copy) NSString *expressId;
@property (nonatomic, copy) NSString *expressNum;
@property (nonatomic, copy) NSString *expressFee;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *zipcode;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, copy) NSString *expressPrice;
@property (nonatomic, copy) NSString *icon;
//订单类型：0:正常订单,1：拼团订单
@property (nonatomic, assign) NSInteger singleType;

@property (nonatomic, copy) NSArray <BLOrderGoodsModel *> *orderGoodsList;

@end


//"id": 1,
//"orderId": 1,
//"goodsId": 3,
//"goodsNum": 1,
//"orderGoodsPrice": 100,
//"orderGoodsName": "2019年真题模拟考试",
//"orderGoodsImg": "http://img.redocn.com/sheji/20151129/nulidefangxiangshujifengmiansheji_5424429.jpg",
//"createBy": null,
//"createTime": null,
//"updateBy": null,
//"updateTime": null,
//"delFlag": "0"

@interface BLOrderGoodsModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsNum;
@property (nonatomic, copy) NSString *orderGoodsPrice;
@property (nonatomic, copy) NSString *orderGoodsName;
@property (nonatomic, copy) NSString *orderGoodsImg;
@property (nonatomic, copy) NSString *createBy;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateBy;
@property (nonatomic, copy) NSString *updateTime;
//拼团结束时间
@property (nonatomic, copy) NSString *endTime;
//拼团的当前状态:0:拼团中，1：拼团成功，2：拼团失败，3:已退款, 4:已发货 5：退款状态，6：发货成功
@property (nonatomic, copy) NSString *groupStatus;

//订单类型：0:正常订单,1：拼团订单
@property (nonatomic, assign) NSInteger singleType;

@end

NS_ASSUME_NONNULL_END
