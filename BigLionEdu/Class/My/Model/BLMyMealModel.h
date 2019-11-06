//
//  BLMyMealModel.h
//  BigLionEdu
//
//  Created by mac on 2019/9/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeModel : NSObject
@property (nonatomic, assign) NSInteger date;// (integer, optional),
@property (nonatomic, assign) NSInteger day;// (integer, optional),
@property (nonatomic, assign) NSInteger hours;// (integer, optional),
@property (nonatomic, assign) NSInteger minutes;// (integer, optional),
@property (nonatomic, assign) NSInteger month;// (integer, optional),
@property (nonatomic, assign) NSInteger nanos;// (integer, optional),
@property (nonatomic, assign) NSInteger seconds;// (integer, optional),
@property (nonatomic, assign) NSInteger time;// (integer, optional),
@property (nonatomic, assign) NSInteger timezoneOffset;// (integer, optional),
@property (nonatomic, assign) NSInteger year;// (integer, optional)
@end

@interface BLMyAllMealModel : NSObject
@property (nonatomic, copy) NSString *coverImg;// (string, optional): 封面图片 ,
@property (nonatomic, assign) NSInteger createBy; //(integer, optional),
@property (nonatomic, copy) NSString *createTime;// (string, optional),
@property (nonatomic, copy) NSString *delFlag;// (string, optional),
@property (nonatomic, copy) NSString *modelDescription; //(string, optional): 描述 ,
@property (nonatomic, assign) NSInteger dueTime;// (integer, optional): 有效期/月 ,
@property (nonatomic, assign) NSInteger functionId; //(integer, optional): 功能类型ID ,
@property (nonatomic, copy) NSString * modelid;// (integer, optional),
@property (nonatomic, assign) NSInteger modelId; //(integer, optional): 模块ID 查 ,
@property (nonatomic, copy) NSString *name; //(string, optional): 名字 ,
@property (nonatomic, assign) NSInteger pageNum;// (integer, optional): 页码 ,
@property (nonatomic, assign) NSInteger pageSize; //(integer, optional): 页数 ,
@property (nonatomic, assign) double price; //(number, optional): 价格 ,
@property (nonatomic, assign) NSInteger updateBy; //(integer, optional),
@property (nonatomic, copy) NSString *updateTime; //(string, optional)
@end

@interface BLMyMyMealModel : NSObject
@property (nonatomic, copy) NSString *coverImg;// (string, optional): 封面图片 ,
@property (nonatomic, copy) TimeModel *createTime ;//(Timestamp, optional): 购买时间 ,
@property (nonatomic, copy) NSString *createTimeStr;// (string, optional): 购买时间-字符串格式 ,
@property (nonatomic, copy) NSString *modelDescription;// (string, optional): 描述 ,
@property (nonatomic, assign) NSInteger dueTime;// (integer, optional): 有效期/月 ,
@property (nonatomic, assign) NSInteger dueTimeTotal;// (number, optional): 总套餐时间，月为单位 ,
@property (nonatomic, copy) NSString *endDate;// (string, optional): 结束时间 ,
@property (nonatomic, copy) NSString *endDateStr;// (string, optional): 结束时间-字符串格式 ,
@property (nonatomic, assign) NSInteger functionId;// (integer, optional): 功能类型ID ,
@property (nonatomic, assign) NSInteger modelid;// (integer, optional),
@property (nonatomic, assign) NSInteger modelId;// (integer, optional): 模块ID ,
@property (nonatomic, copy) NSString *name;// (string, optional): 名字 ,
@property (nonatomic, assign) NSInteger price;// (number, optional): 价格 ,
@property (nonatomic, assign) NSInteger priceTotal;// (number, optional): 总价格
@end



NS_ASSUME_NONNULL_END
