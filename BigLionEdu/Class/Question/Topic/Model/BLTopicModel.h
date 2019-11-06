//
//  BLTopicModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/20.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTopicOptionModel.h"
#import <UIKit/UIKit.h>
#import "BLFillTopicKeyModel.h"

NS_ASSUME_NONNULL_BEGIN
@class BLTopicModel;
@interface BLTopicModel : NSObject


@property (nonatomic, assign) NSInteger setId;

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger functionTypeId;
/** 节 */
@property (nonatomic, strong) NSString *section;

/** 材料题id */
@property (nonatomic, assign) NSInteger materialId;

/** 来源 */
@property (nonatomic, copy)   NSString *source;

/** 材料题编号 */
@property (nonatomic, copy)   NSString *materialNo;


@property (nonatomic, copy)   NSString *title;

@property (nonatomic, strong) NSArray *titleArray;

/** 是否材料：1:材料题， 2 其他 */
@property (nonatomic, strong) NSString *materialType;


@property (nonatomic, strong) NSArray<BLTopicOptionModel *> *optionList;

/** 章 */
@property (nonatomic, strong) NSString *chapter;

/** 是否需要人工干预 */
@property (nonatomic, strong) NSString *isManual;

/** 考点 */
@property (nonatomic, copy)   NSString *testPoint;

/** 分数 */
@property (nonatomic, assign) float score;

/** 类型id */
@property (nonatomic, assign) NSInteger classfierId;

/** 填空数量 */
@property (nonatomic, assign) NSInteger fillNum;

/** 正确答案 */
@property (nonatomic, copy)   NSString *answer;

/** 填空题的答案 */
@property (nonatomic, strong) NSArray *answerDTOList;

@property (nonatomic, copy) NSString *answerString;

@property (nonatomic, strong) NSAttributedString *answerAttString;

@property (nonatomic, assign) NSInteger duration;

/** 1:单选，2多选，3：判断，4:填空， 5：阅读 etc.  6.简答 */
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, assign) NSInteger Id;

/** 每日一练id */
@property (nonatomic, assign) NSInteger questiondDailyId;

/** 是否是每日一练 */
@property (nonatomic, copy)   NSString *isDaily;

/** 错题收藏id */
@property (nonatomic, assign) NSInteger memberQuestionId;

/** 难度系数 */
@property (nonatomic, copy)   NSString *difficultLevel;

/** <#content#> */
@property (nonatomic, assign) NSInteger dailyNum;
@property (nonatomic, copy)   NSString *classfierType;
@property (nonatomic, strong) NSString *material;


/** 是否收藏 */
@property (nonatomic, strong) NSString *isCollection;

/** 题干 解析 */
@property (nonatomic, copy)   NSString *analysis;

//解析过的
@property (nonatomic, strong) NSArray *analysisArray;

/** 备注 */
@property (nonatomic, copy)   NSString *remark;

/** 说明 */
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray<BLTopicModel *> *questionList;

@property (nonatomic, strong) NSArray<BLTopicModel *> *errorQuestionList;


@property (nonatomic, strong) NSMutableAttributedString * titleAttributedString;

@property (nonatomic, strong) NSMutableAttributedString * titleString;

/** 是否选择大狮解帮助 */
@property (nonatomic, assign) BOOL isSelectHelp;

/** 返回的上次答题上传的答案 */
@property (nonatomic, copy) NSString *memAnswer;

@property (nonatomic, strong) UIFont *font;//当前字体
/** 单选
{“type”:”moptionSingle”,”answer”:”A”}
多选
{“type”:”moptionMul”,”answer”:”A,B,C”}
填空
{“type”:”insert”,”answer”:[{“type”:”img”,”value”:”fileName”},{“type”:”text”,”value”:”文字”}]}
判断：
{“type”:”judgment”,”answer”:”1”}//1正确，0错误
语音（面试）
{“type”:”voice”,”answer”:[{“file”:”fileName”,”time”:”15”}]} */

#pragma mark -- 单选
@property (nonatomic, strong, nullable) BLTopicOptionModel *  currentTopicOptionModel;

#pragma mark -- 多选
@property (nonatomic, strong, nullable) NSMutableArray<BLTopicOptionModel *> *  currentTopicOptionModels;

#pragma mark -- 填空
@property (nonatomic, strong) NSArray<BLFillTopicKeyModel *> * fillAnswer;

#pragma mark -- 判断
@property (nonatomic, assign) NSInteger judgment;


#pragma mark -- 材料题
@property (nonatomic, strong) NSAttributedString * materialString;

/** 材料题的提交答案 */
@property (nonatomic, strong) NSArray * submitAnswers;

#pragma mark -- 答案
/** 答案是否正确 */
@property (nonatomic, copy) NSString * isCorrect;

#pragma mark -- 提交答案的数据
@property (nonatomic, strong) NSDictionary * submitAnswer;

#pragma mark -- 题目的位置（组内位置 属于的组）
@property (nonatomic, assign) NSInteger idx;

//该组答案的总题数
@property (nonatomic, assign) NSInteger totalNum;


/** 答题完的解析模式 */
@property (nonatomic, assign) BOOL isParsing;

/** 单题 */
@property (nonatomic, assign) BOOL isSingle;

#pragma mark -- 材料的描述
@property (nonatomic, strong) NSArray * materialArray;

#pragma mark -- 时间
/** 答题的时间段 */
@property (nonatomic, assign) NSInteger timeInterval;

/** 当前答题的开始时间 */
@property (nonatomic, assign) NSInteger startSeconds;

/** 当前答题结束时间 */
@property (nonatomic, assign) NSInteger endSeconds;

/** 是否完成答题 */
@property (nonatomic, assign) BOOL isFinish;


@end

NS_ASSUME_NONNULL_END
