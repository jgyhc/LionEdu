//
//  BLAnswerReportQuestionListModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/** function_id (integer, optional): 模块功能id ,
id (integer, optional),
isRecommend (string, optional): 1, 推荐， 0 正常， 2：全部 ,
liveRecDTOList (Array[课程信息列表返回], optional): 分类列表 ,
modelId (integer, optional): 模块id ,
position (string, optional): 1：首页， 2：答题卡， 3：直播、录播 ，4:面授 ,
sort (string, optional): 展示顺序 ,
title (string, optional): 标题 */
@class BLAnswerReportQuestionItemModel;
@interface BLAnswerReportQuestionListModel : NSObject
@property (nonatomic, copy)   NSString *position;
@property (nonatomic, copy)   NSString *sort;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy)   NSString *isRecommend;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) NSInteger function_id;
@property (nonatomic, strong) NSArray *liveRecDTOList;

@end

@interface BLAnswerReportQuestionItemModel : NSObject
/** address (string, optional): 面授地址 ,
courseHour (integer, optional): 课时个数 ,
coverImg (string, optional): 封面(商城) ,
endEffectiveTime (integer, optional): 有效结束时间 ,
functionTypeId (integer, optional): 功能模块类型Id ,
id (integer, optional): 课程id ,
interviewDate (integer, optional): 面授开始时间 ,
isFree (string, optional): 是否免费：1.是 0.否 ,
isMutipleTutor (string, optional): 1:多个老师， 0： 一个老师 ,
isPurchase (string, optional): 是否购买 1.是 0否 ,
isRecommend (string, optional): 类型：1:推荐， 0： 正常 ,
labelName (string, optional): 标签 ,
lionFilePath (string, optional): 狮享文件地址 ,
liveEndDate (string, optional): 直播结束时间 ,
liveEndDateLog (integer, optional): 直播结束时间-时间戳 ,
liveStartDate (string, optional): 直播开始时间 ,
liveStartDateLog (integer, optional): 直播开始时间-时间戳 ,
modelId (integer, optional): 模块Id ,
noteLocation (string, optional): 讲义下载路径 ,
originPrice (number, optional): 原价 ,
price (number, optional): 直播价格 ,
salesNum (integer, optional): 已售数量 ,
startEffectiveTime (integer, optional): 有效开始时间 ,
title (string, optional): 课程标题 ,
tutorImg (string, optional): 老师照片 ,
tutorName (string, optional): 老师名称 ,
type (string, optional): 0：直播， 1：录播，2：课程， 3：狮享 ,
validDay (integer, optional): 有效期 */

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, assign) NSInteger doingNum;

@property (nonatomic, assign) NSInteger setNum;

@property (nonatomic, copy)   NSString *isFree;
@property (nonatomic, assign) NSInteger liveStartDateLog;
@property (nonatomic, copy)   NSString *isMutipleTutor;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *tutorImg;
@property (nonatomic, copy)   NSString *liveStartDate;
@property (nonatomic, assign) NSInteger endEffectiveTime;
@property (nonatomic, assign) NSInteger functionTypeId;
@property (nonatomic, copy)   NSString *coverImg;
@property (nonatomic, copy)   NSString *isPurchase;
@property (nonatomic, assign) NSInteger liveEndDateLog;
@property (nonatomic, assign) NSInteger salesNum;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, copy)   NSString *noteLocation;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger courseHour;
@property (nonatomic, copy)   NSString *liveEndDate;
@property (nonatomic, assign) NSInteger validDay;
@property (nonatomic, assign) NSInteger originPrice;
@property (nonatomic, assign) NSInteger interviewDate;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, copy)   NSString *tutorName;
@property (nonatomic, copy)   NSString *isRecommend;
@property (nonatomic, copy)   NSString *labelName;
@property (nonatomic, assign) NSInteger startEffectiveTime;
@property (nonatomic, copy)   NSString *lionFilePath;
@property (nonatomic, strong) NSNumber *price;;
@property (nonatomic, copy)   NSString *address;

@property (nonatomic, copy) NSString *endTimeString;

@property (nonatomic, copy) NSString *startTimeString;
@end

NS_ASSUME_NONNULL_END
