//
//  BLRecommendBookModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTrainCoreDoodsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLRecommendBookModel : NSObject
/** createBy (integer, optional),
 createTime (string, optional),
 delFlag (string, optional),
 id (integer, optional),
 kylinCoreDoodsList (Array[商品信息], optional): 图书列表 ,
 modelId (integer, optional): 模块id ,
 title (string, optional): 标题 ,
 updateBy (integer, optional),
 updateTime (string, optional) */
@property (nonatomic, strong) NSNumber * createBy;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, strong) NSNumber * Id;
@property (nonatomic, strong) NSArray<BLTrainCoreDoodsListModel *> *kylinCoreDoodsList;
@property (nonatomic, strong) NSNumber * modelId;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) NSNumber * updateBy;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, copy)   NSString *createTime;

@end

NS_ASSUME_NONNULL_END
