//
//  BLTrainListModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLRecommendBookModel.h"
#import "BLTrainBaseTitleModel.h"
#import "BLTrainCoreNewsModel.h"
#import "BLTrainIndexFunctionsModel.h"
#import "BLTrainModuleBannersModel.h"
#import "BLRecommendBookModel.h"
#import "BLCoreQuestionSetsModel.h"
#import "BLIndexTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainListModel : NSObject
/**  模考信息 */
@property (nonatomic, strong) NSArray<BLCoreQuestionSetsModel *> *coreQuestionSets;

@property (nonatomic, strong) BLIndexTestModel *indexTest;

/** 推荐图书信息 */
@property (nonatomic, strong) BLRecommendBookModel *recommendBookDTO;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy)   NSString *title;

/** 轮播图信息 */
@property (nonatomic, strong) NSArray<BLTrainModuleBannersModel *> *moduleBanners;

/** 轮播图信息 */
@property (nonatomic, strong) NSArray<NSString *> *moduleStrBanners;

/** 今日头条信息 */
@property (nonatomic, strong) NSArray<BLTrainCoreNewsModel *> *coreNews;

/** 功能模块信息 */
@property (nonatomic, strong) NSArray<BLTrainIndexFunctionsModel *> *indexFunctions;

/** 子标题信息 */
@property (nonatomic, strong) NSArray<BLTrainBaseTitleModel *> *baseTitleDTOS;
@end

NS_ASSUME_NONNULL_END
