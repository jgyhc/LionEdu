//
//  BLGoodsModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/7.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/** coverImg (string, optional): 封面 ,
 discountTypePick (integer, optional): 折扣类型 ,
 id (integer, optional),
 isRecommend (string, optional): 1:推荐， 0： 正常 ,
 labelId (integer, optional): 商品标签ID ,
 labelName (string, optional): 商品标签 ,
 memberId (integer, optional): 用户id ,
 modelId (integer, optional): 模块id ,
 price (number, optional): 商品价格 ,
 salesNum (integer, optional): 已卖出并付款数量 ,
 title (string, optional): 商品简称 ,
 type (string, optional): 0：书籍1：试卷2：直播3：套卷(套卷都不显示）4:录播 ,
 typeId (integer, optional): 对应真题或者课程id（用于定位该商品在哪张表）
 }
 
 */
@interface BLGoodsModel : NSObject
@property (nonatomic, copy)   NSString *coverImg;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger infoId;
@property (nonatomic, assign) NSInteger salesNum;
@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, assign) NSInteger discountTypePick;
@property (nonatomic, copy)   NSString *isRecommend;
@property (nonatomic, assign) NSInteger memberId;
@property (nonatomic, strong) NSNumber* price;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) NSInteger labelId;
@property (nonatomic, copy)   NSString *labelName;
@property (nonatomic, assign) NSInteger modelId;

@end

NS_ASSUME_NONNULL_END
