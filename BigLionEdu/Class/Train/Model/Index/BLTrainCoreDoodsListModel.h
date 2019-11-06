//
//  BLTrainCoreDoodsListModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainCoreDoodsListModel : NSObject
/** coverImg (string, optional): 封面 ,
 createBy (integer, optional),
 createTime (string, optional),
 delFlag (string, optional),
 discountTypePick (integer, optional): 折扣类型 ,
 id (integer, optional),
 isRecommend (string, optional): 1:推荐， 0： 正常 ,
 modelId (integer, optional): 模块id ,
 price (number, optional): 商品价格 ,
 salesNum (integer, optional): 已卖出并付款数量 ,
 title (string, optional): 商品简称 ,
 type (string, optional): 0：书籍 ,
 updateBy (integer, optional),
 updateTime (string, optional) */
@property (nonatomic, copy)   NSString *coverImg;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, strong) NSNumber * salesNum;
@property (nonatomic, strong) NSNumber * updateBy;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, strong) NSNumber * discountTypePick;
@property (nonatomic, copy)   NSString *isRecommend;
@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) NSNumber * modelId;
@property (nonatomic, strong) NSNumber * createBy;

@end

NS_ASSUME_NONNULL_END
