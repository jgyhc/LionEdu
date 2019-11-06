//
//  BLTrainBaseTitleModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTrainBaseCoreLiveRecListModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainBaseTitleModel : NSObject

/** createBy (integer, optional),
 createTime (string, optional),
 delFlag (string, optional),
 function_id (integer, optional): 模块功能id ,
 id (integer, optional),
 isRecommend (string, optional): 1, 推荐， 0 正常， 2：全部 ,
 kylinCoreLiveRecList (Array[课程信息], optional): 分类列表 ,
 modelId (integer, optional): 模块id ,
 position (string, optional): 1：首页， 2：答题卡， 3：直播、录播 ，4:面授 ,
 sort (string, optional): 展示顺序 ,
 title (string, optional): 标题 ,
 updateBy (integer, optional),
 updateTime (string, optional) */

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger updateBy;
@property (nonatomic, strong) NSArray<BLTrainBaseCoreLiveRecListModel *> *liveRecDTOList;
@property (nonatomic, copy)   NSString *isRecommend;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, assign) NSInteger function_id;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, copy)   NSString *sort;
@property (nonatomic, assign) NSInteger createBy;

@property (nonatomic, strong) NSArray * items;

#pragma mark -- custom
@property (nonatomic, assign) CGFloat textWidth;

@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
