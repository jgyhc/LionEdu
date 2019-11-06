//
//  BLTrainShareDetailModel.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYText.h>
@class BLTrainShareDetailTutorModel, BLTrainShareDetailCourseModel;
NS_ASSUME_NONNULL_BEGIN

@interface BLTrainCurriculumDetailModel : NSObject

//是否收费：0:收费， 1：免费
@property (nonatomic, copy) NSString *isFree;
//1:多个老师， 0： 一个老师
@property (nonatomic, copy) NSString *isMutipleTutor;
//课程标题
@property (nonatomic, copy) NSString *title;
//有效结束时间
@property (nonatomic, copy) NSString *endEffectiveTime;
//功能模块类型Id
@property (nonatomic, copy) NSString *functionTypeId;
//封面(商城)
@property (nonatomic, copy) NSString *coverImg;
//是否购买 1.是 0否
@property (nonatomic, copy) NSString *isPurchase;
//商品id
@property (nonatomic, copy) NSString *goodsId;
//课程类型 ：0：直播， 1：录播，2：课程， 3：狮享
@property (nonatomic, copy) NSString *type;
//讲义下载路径
@property (nonatomic, copy) NSString *noteLocation;
//课程id
@property (nonatomic, copy) NSString *Id;
//课时个数
@property (nonatomic, copy) NSString *courseHour;

@property (nonatomic, strong) NSArray <BLTrainShareDetailTutorModel *>*tutorDTOS;
@property (nonatomic, copy) NSString *singleCreateTime;

@property (nonatomic, strong) NSArray <BLTrainShareDetailCourseModel *>*liveRecCourseTypeDTOS;
@property (nonatomic, copy) NSString *originPrice;
//模块Id
@property (nonatomic, copy) NSString *modelId;
//面授开始时间
@property (nonatomic, copy) NSString *interviewDate;
//类型：1:推荐， 0： 正常
@property (nonatomic, copy) NSString *isRecommend;
//有效开始时间
@property (nonatomic, copy) NSString *startEffectiveTime;
//价格
@property (nonatomic, copy) NSString *price;
//狮享文件地址
@property (nonatomic, copy) NSString *lionFilePath;

//是否是视频
@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, copy) NSString *isBuy;
//面授地址
@property (nonatomic, copy) NSString *address;
//课程介绍
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, strong) NSAttributedString *introduceAttr;


@end

@interface BLTrainShareDetailTutorModel : NSObject

//老师简介
@property (nonatomic, copy) NSString *desc;
//顺序
@property (nonatomic, copy) NSString *tutorSort;
//教师姓名
@property (nonatomic, copy) NSString *name;
//照片
@property (nonatomic, copy) NSString *headImg;
//职称
@property (nonatomic, copy) NSString *tutorTitle;

@end

@interface BLTrainShareDetailCourseModel : NSObject

@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *courseLiveStartDate;
@property (nonatomic, copy) NSString *courseLiveStartDateLog;
@property (nonatomic, copy) NSString *courseLiveEndDate;
@property (nonatomic, copy) NSString *courseLiveEndDateLog;
@property (nonatomic, copy) NSString *courseTitle;
@property (nonatomic, copy) NSString *totalHours;

@end



NS_ASSUME_NONNULL_END
