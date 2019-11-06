
//
//  BLTopicPaperModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/18.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTopicPaperModel.h"
#import <NSArray+BlocksKit.h>


@implementation BLTopicPaperModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"questionDTOS" : [BLTopicModel class],
             @"answerCardDTOS": [BLAnswerCardModel class]
             };
}

- (void)dataProcessing {
     __block NSInteger startTime = 0;
    [_answerCardDTOS enumerateObjectsUsingBlock:^(BLAnswerCardModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        startTime = startTime + [obj.usedTime integerValue];
        [_questionDTOS enumerateObjectsUsingBlock:^(BLTopicModel *  _Nonnull topic, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([topic.materialType isEqualToString:@"1"]) {
                [topic.questionList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull subTopic, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (subTopic.Id == obj.questionId) {
                        subTopic.memAnswer = obj.memAnswer;
//                        subTopic.timeInterval = [obj.usedTime integerValue];
                    }
                }];
            }else {
                if (topic.Id == obj.questionId) {
                    topic.memAnswer = obj.memAnswer;
//                    topic.timeInterval = [obj.usedTime integerValue];
                }
            }
        }];
    }];
    _startTime = startTime;
}

- (void)setQuestionDTOS:(NSArray<BLTopicModel *> *)questionDTOS {
    _questionDTOS = questionDTOS;
    NSMutableArray *sections = [NSMutableArray array];//划分出分组
    __block NSString * isManual = @"0";
    [questionDTOS enumerateObjectsUsingBlock:^(BLTopicModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.functionTypeId = _functionTypeId;
        obj.setId = _setId;
        obj.modelId = _modelId;
        obj.isDaily = @"0";
        if ([obj.isManual isEqualToString:@"1"]) {
            isManual = @"1";
        }
        BLTopicSectionModel *sectionModel = [sections bk_match:^BOOL(BLTopicSectionModel * section) {
            return section.Id == obj.classfierId;
        }];
        if (!sectionModel) {
            sectionModel = ({
                BLTopicSectionModel *sectionModel = [BLTopicSectionModel new];
                sectionModel.Id = obj.classfierId;
                sectionModel.classfierType = obj.classfierType;
                sectionModel;
            });
            [sections addObject:sectionModel];
        }
        [sectionModel.topicList addObject:obj];
    }];
    _isManual = isManual;
    self.sectionTopicList = sections;//获取一组的题目数
    
    [self.sectionTopicList enumerateObjectsUsingBlock:^(BLTopicSectionModel *  _Nonnull sectionModel, NSUInteger section, BOOL * _Nonnull stop) {
        __block NSInteger totalNum = 0;
        [sectionModel.topicList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.materialType isEqualToString:@"1"]) {
                totalNum = totalNum + obj.questionList.count;
                
            }else {
                totalNum ++;
                
            }
        }];
        sectionModel.totalNum = totalNum;
    }];
    //确定每一道题目的位置
    __block NSInteger index = 0;
    [self.sectionTopicList enumerateObjectsUsingBlock:^(BLTopicSectionModel *  _Nonnull sectionModel, NSUInteger section, BOOL * _Nonnull stop) {
        [sectionModel.topicList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.materialType isEqualToString:@"1"]) {
                [obj.questionList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull subObj, NSUInteger subIdx, BOOL * _Nonnull stop) {
                    index ++;
                    subObj.idx = index;
                    subObj.totalNum = sectionModel.totalNum;
                }];
            }else {
                index ++;
                obj.totalNum = sectionModel.totalNum;
                obj.idx = index;
            }
        }];
    }];
}

- (BOOL)isAllFinish {
    __block BOOL isAll = YES;
    [self.questionDTOS enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isFinish) {
            isAll = NO;
        }
    }];
    _isAllFinish = isAll;
    return isAll;
}




@end
