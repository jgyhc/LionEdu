//
//  BLTopicPaperModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/18.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTopicModel.h"
#import "BLAnswerCardModel.h"
#import "BLTopicSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLTopicPaperModel : NSObject

@property (nonatomic, strong) NSArray<BLTopicModel *> * questionDTOS;

@property (nonatomic, strong) NSArray<BLAnswerCardModel *> * answerCardDTOS;

@property (nonatomic, strong) NSArray<BLTopicSectionModel *> * sectionTopicList;

/** 试卷是否需要时间 */
@property (nonatomic, assign) NSInteger duration;

/** 是否需要人工干预 */
@property (nonatomic, copy) NSString * isManual;

@property (nonatomic, assign) NSInteger setRecId;

/** 上次答题之后的结束时间  本次的开始时间 */
@property (nonatomic, assign) NSInteger startTime;

@property (nonatomic, assign) NSInteger setId;

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger functionTypeId;

@property (nonatomic, copy) NSString * topicTitle;

@property (nonatomic, assign) BOOL isAllFinish;

@property (nonatomic, assign) double startEffectiveTime;

@property (nonatomic, assign) double endEffectiveTime;

- (void)dataProcessing;
@end

NS_ASSUME_NONNULL_END
