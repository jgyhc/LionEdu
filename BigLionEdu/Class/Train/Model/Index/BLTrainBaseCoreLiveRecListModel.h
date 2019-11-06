//
//  BLTrainBaseCoreLiveRecListModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface BLTrainBaseCoreLiveRecListModel : NSObject
/** courseHour (integer, optional): 课时个数 ,
 createBy (integer, optional),
 createTime (string, optional),
 delFlag (string, optional),
 discountTypePick (integer, optional): 列表展示折扣类型 ,
 functionTypeId (integer, optional): 功能模块类型Id ,
 id (integer, optional),
 isFree (string, optional): 0:收费， 1：免费 ,
 isMutipleTutor (string, optional): 1:多个老师， 0： 一个老师 ,
 isRecommend (string, optional): 1:推荐， 0： 正常 ,
 liveEndDate (string, optional): 结束时间 ,
 liveStartDate (string, optional): 开始时间 ,
 modelId (integer, optional): 模块Id ,
 noteLocation (string, optional): 讲义下载路径 ,
 price (number, optional): 直播价格 ,
 salesNum (integer, optional): 已售数量 ,
 title (string, optional): 直播课程简介 ,
 tutorImg (string, optional): 直播老师照片 ,
 tutorName (string, optional): 直播老师名称 ,
 type (string, optional): 0：直播， 1：录播，2：课程， 3：狮享 ,
 updateBy (integer, optional),
 updateTime (string, optional) */


@property (nonatomic, copy)   NSString *isFree;
@property (nonatomic, copy)   NSString *isMutipleTutor;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *tutorImg;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, copy)   NSString *liveStartDate;
@property (nonatomic, strong) NSNumber * functionTypeId;
@property (nonatomic, strong) NSNumber * discountTypePick;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, strong) NSNumber * salesNum;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, copy)   NSString *noteLocation;
@property (nonatomic, strong) NSNumber * Id;
@property (nonatomic, strong) NSNumber * courseHour;
@property (nonatomic, copy)   NSString *liveEndDate;
@property (nonatomic, strong) NSNumber * createBy;
@property (nonatomic, strong) NSNumber * updateBy;
@property (nonatomic, strong) NSNumber * modelId;
@property (nonatomic, copy)   NSString *tutorName;
@property (nonatomic, copy)   NSString *isRecommend;
@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, strong) NSNumber * price;


@end

NS_ASSUME_NONNULL_END
