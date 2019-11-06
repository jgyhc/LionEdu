//
//  BLQuestionsModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/16.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLQuestionsModel : NSObject
/** createBy (integer, optional),
 createTime (string, optional),
 delFlag (string, optional),
 doingNum (integer, optional): 多少人正在做此类型的题目 ,
 functionId (integer, optional): 功能Id ,
 id (integer, optional): 模块功能类型id ,
 img (string, optional): 图片 ,
 introduction (string, optional): 介绍 ,
 isDaily (string, optional): 每日一练:Y, 其他为N ,
 isFree (string, optional): 是否免费 ,
 isRecommend (string, optional): 1：首页推荐， 2：答题卡题库推荐，3：都推荐 0：其他 ,
 isTest (string, optional): 1: 模考大赛，0：其他 ,
 level (string, optional): 等级 ,
 modelId (integer, optional): 模块id ,
 parentId (integer, optional): 上级id ,
 price (number, optional): 价格 ,
 setNum (integer, optional): 套题数量 ,
 sort (string, optional): 展示顺序 ,
 title (string, optional): 标题 ,
 topPid (integer, optional): 最上层父节点id ,
 type (string, optional): 类型 1:题库，2：直播，3：录播，4：狮享等等 ,
 updateBy (integer, optional),
 updateTime (string, optional) */

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, assign) NSInteger goodsId;

/** 是否购买 1.是 0否 */
@property (nonatomic, copy) NSString *isPurchase;

/** id */
@property (nonatomic, copy) NSString *createTime;

/** 是否免费 */
@property (nonatomic, copy) NSString *isFree;
@property (nonatomic, copy) NSString *updateTime;

/** 类型 1:题库，2：直播，3：录播，4：狮享等等 */
@property (nonatomic, copy) NSString *type;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/**  1：首页推荐， 2：答题卡题库推荐，3：都推荐 0：其他 */
@property (nonatomic, copy) NSString *isRecommend;

/**  图片  */
@property (nonatomic, copy) NSString *img;

/** 多少人正在做此类型的题目 */
@property (nonatomic, assign) NSInteger doingNum;

/** 展示顺序 */
@property (nonatomic, copy) NSString *sort;


@property (nonatomic, assign) NSInteger createBy;
@property (nonatomic, assign) NSInteger updateBy;

/** 模块id */
@property (nonatomic, assign) NSInteger modelId;

/** 套题数量  */
@property (nonatomic, assign) NSInteger setNum;

@property (nonatomic, copy) NSString *delFlag;

@property (nonatomic, copy) NSString *labelName;

/** 每日一练:Y, 其他为N */
@property (nonatomic, copy) NSString *isDaily;

/** 最上层父节点id */
@property (nonatomic, assign) NSInteger topPid;

/**  等级 */
@property (nonatomic, copy) NSString *level;

/** 介绍 */
@property (nonatomic, copy) NSString *introduction;

/** 价格 */
@property (nonatomic, strong) NSNumber *price;

/** 上级id */
@property (nonatomic, assign) NSInteger parentId;

/**  1: 模考大赛，0：其他 */
@property (nonatomic, copy) NSString *isTest;

/** 功能Id */
@property (nonatomic, assign) NSInteger functionId;

/** 每一套的价格 */
@property (nonatomic, strong) NSNumber *eachPrice;


@property (nonatomic, copy) NSString *effectiveTimeString;

@property (nonatomic, assign) double effectiveTime;


@property (nonatomic, strong) NSAttributedString *priceAttString;

/** 是否是预售的卷子 */
@property (nonatomic, copy) NSString *isAdvance;

/** 预约卷子   开始答题时间 */
@property (nonatomic, copy) NSString *advanceDate;

//是否已经开始预售了
@property (nonatomic, assign) BOOL isStart;

@property (nonatomic, assign) BOOL isAllBuy;

@property (nonatomic, assign) double startEffectiveTime;

@property (nonatomic, copy) NSString *startEffectiveTimeString;

@property (nonatomic, assign) double endEffectiveTime;

@property (nonatomic, copy) NSString *endEffectiveTimeString;
@end

NS_ASSUME_NONNULL_END
