//
//  BLTrainIndexFunctionsModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainIndexFunctionsModel : NSObject
/** createBy (integer, optional),
 createTime (string, optional),
 delFlag (string, optional),
 id (integer, optional): id ,
 img (string, optional): 图片 ,
 modelId (integer, optional): 模块id ,
 sort (string, optional): 展示顺序 ,
 title (string, optional): 标题 ,
 type (string, optional): 类型 1: 题库， 0：课程， 2： 商城， 3： 面试 等等 ,
 updateBy (integer, optional),
 updateTime (string, optional) */

@property (nonatomic, copy)   NSString *img;
@property (nonatomic, strong) NSNumber * createBy;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, strong) NSNumber * Id;
@property (nonatomic, strong) NSNumber * modelId;
@property (nonatomic, copy)   NSString *sort;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) NSNumber * updateBy;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, copy)   NSString *createTime;
@end

NS_ASSUME_NONNULL_END
