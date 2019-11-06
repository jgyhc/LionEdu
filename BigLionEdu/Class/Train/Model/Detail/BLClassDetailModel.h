//
//  BLClassDetailModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLClassScheduleModel.h"
#import "BLClassDetailTeacherModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLClassDetailModel : NSObject

/** address (string, optional): 面授地址 ,
courseHour (integer, optional): 课时个数 ,
coverImg (string, optional): 封面(商城) ,
endEffectiveTime (integer, optional): 有效结束时间 ,
functionTypeId (integer, optional): 功能模块类型Id ,
id (integer, optional): 课程id ,
interviewDate (integer, optional): 面授开始时间 ,
introduce (string, optional): 课程介绍 ,
isFree (string, optional): 是否免费：1.是 0.否 ,
isMutipleTutor (string, optional): 1:多个老师， 0： 一个老师 ,
isPurchase (string, optional): 是否购买 1.是 0否 ,
isRecommend (string, optional): 类型：1:推荐， 0： 正常 ,
lionFilePath (string, optional): 狮享文件地址 ,
liveRecCourseTypeDTOS (Array[课程表分类返回], optional): 课程分类表 ,
modelId (integer, optional): 模块Id ,
noteLocation (string, optional): 讲义下载路径 ,
originPrice (number, optional): 原价 ,
startEffectiveTime (integer, optional): 有效开始时间 ,
title (string, optional): 课程标题 ,
tutorDTOS (Array[老师信息返回], optional): 老师信息 */
@property (nonatomic, copy)   NSString *isFree;
@property (nonatomic, copy)   NSString *isMutipleTutor;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) double endEffectiveTime;
@property (nonatomic, assign) NSInteger functionTypeId;
@property (nonatomic, copy)   NSString *coverImg;
@property (nonatomic, copy)   NSString *isPurchase;
@property (nonatomic, copy)   NSString *noteLocation;
@property (nonatomic, assign) NSInteger Id;
//    课程类型 ：0：直播， 1：录播，2：课程， 3：狮享
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger courseHour;
@property (nonatomic, strong) NSArray<BLClassDetailTeacherModel *> *tutorDTOS;
@property (nonatomic, strong) NSString *singleCreateTime;
@property (nonatomic, strong) NSArray<BLClassScheduleModel *> *liveRecCourseTypeDTOS;
@property (nonatomic, strong) NSNumber * originPrice;
@property (nonatomic, strong) NSNumber * price;

@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, strong) NSString *interviewDate;
@property (nonatomic, copy)   NSString *isRecommend;
@property (nonatomic, assign) double startEffectiveTime;
@property (nonatomic, copy)   NSString *lionFilePath;
@property (nonatomic, copy)   NSString *address;
@property (nonatomic, strong) NSString *introduce;


#pragma mark -- custom
@property (nonatomic, copy) NSString *startEffectiveTimeString;

@property (nonatomic, copy) NSString *endEffectiveTimeString;
@end

NS_ASSUME_NONNULL_END
