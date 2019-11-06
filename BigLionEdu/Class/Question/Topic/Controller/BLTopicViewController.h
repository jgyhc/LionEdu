//
//  BLTopicViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTopicOptionModel.h"
#import "BLTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLTopicViewController : UIViewController

@property (nonatomic, assign) BOOL isSubController;

//试卷的答题时间  非要从外面带 (分钟)
@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, assign) NSInteger setId;

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger functionTypeId;

/** 每日一练模型 */
@property (nonatomic, strong) BLTopicModel * topicModel;

/** 材料题模型 */
@property (nonatomic, strong) BLTopicModel * materialTopicModel;

/** 单题的机械  收藏、错题 */
@property (nonatomic, strong) NSDictionary * analysisParams;

//解析的数据源
@property (nonatomic, strong) NSArray<BLTopicModel *> *analysisTopicList;
@property (nonatomic, strong) BLTopicModel * currentAnalysisModel;//当前正在解析的题 用于定位解析得题

//是否是错题解析
@property (nonatomic, assign) BOOL isError;

@property (nonatomic, copy) NSString *topicTitle;

@property (nonatomic, copy) void(^didFinishHandler)(NSInteger index, BLTopicModel *model);

@end

NS_ASSUME_NONNULL_END
