//
//  BLMyClassListModel.h
//  BigLionEdu
//
//  Created by mac on 2019/8/30.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BLMyClassTotursModel : NSObject
@property (nonatomic, assign) NSInteger createBy;// (integer, optional),
@property (nonatomic, copy)   NSString * createTime;// (string, optional),
@property (nonatomic, copy)   NSString *delFlag ;//(string, optional),
@property (nonatomic, assign) NSInteger  modelId;// (integer, optional),
@property (nonatomic, assign) NSInteger liveRecId;// (integer, optional): 课程id ,
@property (nonatomic, assign) NSInteger  sort;// (integer, optional): 排序 ,
@property (nonatomic, assign) NSInteger tutorId;// (integer, optional): 老师Id ,
@property (nonatomic, assign) NSInteger updateBy;// (integer, optional),
@property (nonatomic, copy)   NSString *updateTime;// (string, optional)
@end

@interface BLMyClassListModel : NSObject

@property (nonatomic, copy) NSString *address;// (string, optional): 面授地址 ,
@property (nonatomic, assign) NSInteger courseHour;//(integer, optional): 课时个数 ,
@property (nonatomic, copy) NSString *coverImg;// (string, optional): 封面(商城) ,
@property (nonatomic, assign) NSInteger createBy;// (integer, optional),
@property (nonatomic, copy) NSString *createTime;// (string, optional),
@property (nonatomic, copy) NSString *delFlag;// (string, optional),
@property (nonatomic, assign) NSInteger discountTypePick;// (integer, optional): 列表展示折扣类型 ,
@property (nonatomic, assign) NSInteger functionTypeId;// (integer, optional): 功能模块类型Id 查 ,
@property (nonatomic, copy)NSArray *functionTypeIds;// (Array[integer], optional),
@property (nonatomic, assign) NSInteger modelid;// (integer, optional),
@property (nonatomic, copy) NSString *introduce;// (string, optional): 课程介绍 ,
@property (nonatomic, copy) NSString *isFree;// (string, optional): 0:收费， 1：免费 查 ,
@property (nonatomic, copy) NSString *isMutipleTutor;// (string, optional): 1:多个老师， 0： 一个老师 ,
@property (nonatomic, copy) NSString *isRecommend;// (string, optional): 1:推荐， 0： 正常 查 ,
@property (nonatomic, assign) NSInteger levelId ;//(integer, optional): 大于等于该等级的可以免费试用 ,
@property (nonatomic, copy) NSString *liveEndDate;// (string, optional): 结束时间 ,
@property (nonatomic, copy) NSString *iveStartDate;// (string, optional): 开始时间 ,
@property (nonatomic, assign) NSInteger modelId;// (integer, optional): 模块Id 查 ,
@property (nonatomic, copy) NSString *noteLocation;// (string, optional): 讲义下载路径 ,
@property (nonatomic, assign) NSInteger originPrice;// (number, optional): 原价 ,
@property (nonatomic, assign) NSInteger pageNum;// (integer, optional): 页码 ,
@property (nonatomic, assign) NSInteger pageSize;// (integer, optional): 页数 ,
@property (nonatomic, assign) NSInteger price;// (number, optional): 直播价格 ,
@property (nonatomic, assign) NSInteger salesNum;// (integer, optional): 已售数量 ,
@property (nonatomic, copy) NSString *title ;//(string, optional): 课程标题 查 ,
@property (nonatomic, copy)NSArray <BLMyClassTotursModel *>*toturs;// (Array[课程和老师关系], optional): 直播老师 新增时需要 ,
@property (nonatomic, copy) NSString *tutorImg;// (string, optional): 直播老师照片 ,
@property (nonatomic, copy) NSString *tutorName;// (string, optional): 直播老师名称 ,
@property (nonatomic, copy) NSString  *type;// (string, optional): 0：直播， 1：录播，2：课程， 3：狮享 查 ,
@property (nonatomic, assign) NSInteger updateBy;// (integer, optional),
@property (nonatomic, copy) NSString *updateTime;// (string, optional)
@end


