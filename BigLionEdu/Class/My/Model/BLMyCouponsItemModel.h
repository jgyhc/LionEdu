//
//  BLMyCouponsItemModel.h
//  BigLionEdu
//
//  Created by mac on 2019/8/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BLMyCouponslistModel;

@interface BLMyCouponsItemModel : NSObject

@property (nonatomic, strong) NSString *endRow;
@property (nonatomic, strong) NSArray <BLMyCouponslistModel *> *list;
@property (nonatomic, assign)BOOL isLastPage;
@property (assign)NSInteger pageNum;
@end

@interface BLMyCouponslistModel : NSObject
@property (nonatomic ,assign) BOOL isSelected; //是否被选中
@property (nonatomic ,assign) BOOL isDrawed; //是否被选中
@property (nonatomic, strong) NSString *couponType;  //优惠券类型
@property (nonatomic, strong) NSString *createBy;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *delFlag;
@property (nonatomic, strong) NSString *functionTypeId;  //功能类型id ,
@property (nonatomic, strong) NSString *modelid;
@property (nonatomic, strong) NSString *instruction;  // 使用说明
@property (nonatomic, strong) NSString *isDiscount;   //1：折扣券， 2：满减券 等等 ,
@property (nonatomic, strong) NSString *isLimited;    //是有限制金额要求 1是 0否 ,
@property (nonatomic, strong) NSString *isOnline;     // 线上或线下优惠卷 1线上 0线下 ,
@property (nonatomic, strong) NSString *isPublish;     // 是否已经发布 1是 0否 ,
@property (nonatomic, strong) NSString *isSingle;     // 优惠券是否复用 0是 1否 ,
@property (nonatomic, strong) NSString *levelId;      // 会员等级
@property (nonatomic, strong) NSString *modelId;      //  模块Id ,
@property (nonatomic, strong) NSString *overPrice;     // 限制金额（条件） ,
@property (nonatomic, strong) NSString *pageNum;      //页码
@property (nonatomic, strong) NSString *pageSize;      //页数
@property (nonatomic, strong) NSString *postedNum;    //已发放个数
@property (nonatomic, strong) NSString *qrImg;       //  线下二维码生成地址 ,
@property (nonatomic, strong) NSString *saleValue;    //折扣值或者满减优惠值
@property (nonatomic, strong) NSString *title;    //  标题
@property (nonatomic, strong) NSString *totalNum;  // 优惠券个数
@property (nonatomic, strong) NSString *updateBy;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *validDay;  //有效期
@property (nonatomic, assign) NSInteger status; //用户优惠券类型（1:已使用，2：未使用，3：已过期）

@end

NS_ASSUME_NONNULL_END
