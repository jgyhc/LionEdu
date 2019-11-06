//
//  BLCurriculumModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKDownloader.h"
NS_ASSUME_NONNULL_BEGIN
/** courseHour (integer, optional): 课时个数 ,
 coverImg (string, optional): 封面(商城) ,
 functionTypeId (integer, optional): 功能模块类型Id ,
 id (integer, optional): 课程id ,
 introduce (string, optional): 课程介绍 ,
 isFree (string, optional): 0:收费， 1：免费 ,
 isMutipleTutor (string, optional): 1:多个老师， 0： 一个老师 ,
 labelName (string, optional): 标签 ,
 liveEndDate (string, optional): 直播结束时间 ,
 liveEndDateLog (integer, optional): 直播结束时间-时间戳 ,
 liveStartDate (string, optional): 直播开始时间 ,
 liveStartDateLog (integer, optional): 直播开始时间-时间戳 ,
 modelId (integer, optional): 模块Id ,
 originPrice (number, optional): 原价 ,
 price (number, optional): 直播价格 ,
 salesNum (integer, optional): 已售数量 ,
 title (string, optional): 课程标题 ,
 tutorImg (string, optional): 老师照片 ,
 tutorName (string, optional): 老师名称 ,
 type (string, optional): 0：直播， 1：录播，2：课程， 3：狮享 ,
 validDay (integer, optional): 有效期 */
@interface BLCurriculumModel : NSObject

@property (nonatomic, copy)   NSString *isFree;
@property (nonatomic, assign) NSInteger liveStartDateLog;
@property (nonatomic, copy)   NSString *isMutipleTutor;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *tutorImg;
@property (nonatomic, copy)   NSString *liveStartDate;
@property (nonatomic, assign) NSInteger functionTypeId;
@property (nonatomic, copy)   NSString *coverImg;
@property (nonatomic, assign) NSInteger liveEndDateLog;
@property (nonatomic, assign) NSInteger salesNum;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, assign) NSInteger validDay;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger courseHour;
@property (nonatomic, copy)   NSString *liveEndDate;
@property (nonatomic, assign) NSInteger originPrice;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, copy)   NSString *tutorName;
@property (nonatomic, copy)   NSString *labelName;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, copy)   NSString *introduce;
@property (nonatomic, assign) NSInteger isPurchase;
@property (nonatomic, copy) NSString *noteLocation;

//讲义下载情况
@property (nonatomic, copy) NSString *noteStateStr;
@property (nonatomic, strong) FKTask *task;
@property (nonatomic, assign) BOOL isCanDownLoad;

@end

NS_ASSUME_NONNULL_END
