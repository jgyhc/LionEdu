//
//  BLQuestionsClassificationModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/30.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLGetTestPaperQuestionAPI.h"
#import "ZLTableViewDelegateManager.h"
#import "BLQuestionBankHeaderTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BLQuestionsClassificationModelDelegate <NSObject>

- (void)updateTableView;
- (void)headerCellDidSelect:(id)model;

@end

@interface BLQuestionsClassificationModel : NSObject<MJAPIBaseManagerDelegate, CTAPIManagerParamSource, BLQuestionBankHeaderTableViewCellDelegate>
/** allParentId (string): 所有父级Id，用','隔开 ,
 doingNum (integer, optional): 多少人正在做此类型的题目 ,
 functionId (integer): 功能Id ,
 goodsId (integer, optional): 商品id ,
 id (integer, optional): 模块功能类型id ,
 img (string): 图片 ,
 introduction (string, optional): 介绍 ,
 isDaily (string): 每日一练:Y, 其他为N ,
 isFree (string): 是否免费 ,
 isPurchase (string, optional): 是否购买 1.是 0否 ,
 isRecommend (string, optional): 1：首页推荐， 2：答题卡题库推荐，3：都推荐 0：其他 ,
 isTest (string): 1: 模考大赛，0：其他 ,
 level (string, optional): 等级 ,
 modelId (integer): 模块id ,
 parentId (integer): 上级id ,
 price (number): 价格 ,
 setNum (integer, optional): 套题数量 ,
 sort (string): 展示顺序 ,
 title (string): 标题 ,
 topPid (integer): 最上层父节点id ,
 type (string): 类型 1:题库，2：直播，3：录播，4：狮享等等 */
@property (nonatomic, copy)   NSString *isDaily;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, copy)   NSString *isTest;
@property (nonatomic, assign) NSInteger createBy;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, assign) NSInteger functionId;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *isRecommend;
@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, assign) NSInteger topPid;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, copy)   NSString *sort;
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, copy) NSString * img;
@property (nonatomic, copy) NSString * introduction;
@property (nonatomic, assign) NSInteger doingNum;

@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, assign) NSInteger setNum;

@property (nonatomic, copy) NSString *labelName;


@property (nonatomic, assign) BOOL open;

@property (nonatomic, strong) NSArray * subCellModels;

@property (nonatomic, strong) BLGetTestPaperQuestionAPI * getTestPaperQuestionAPI;

@property (nonatomic, weak) id<BLQuestionsClassificationModelDelegate> delegate;

@property (nonatomic, strong) ZLTableViewRowModel * currentRowModel;

/** 是否是预售的卷子 */
@property (nonatomic, copy) NSString *isAdvance;

/** 预约卷子   开始答题时间 */
@property (nonatomic, copy) NSString *advanceDate;

- (void)reloadData;


@property (nonatomic, copy) NSString *years;

@property (nonatomic, copy) NSString *startYears;

@property (nonatomic, copy) NSString *entYears;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString *searchTitle;

@property (nonatomic, assign) double startEffectiveTime;

@property (nonatomic, assign) double endEffectiveTime;
@end

NS_ASSUME_NONNULL_END
