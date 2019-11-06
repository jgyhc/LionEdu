//
//  BLMyRecordModel.h
//  BigLionEdu
//
//  Created by mac on 2019/9/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMyRecordTypeDotsModel : NSObject
@property (nonatomic, assign) NSInteger functionId;// (integer, optional): 功能Id ,
@property (nonatomic, assign) NSInteger modelid;// (integer, optional): 模块功能类型id ,
@property (nonatomic, copy) NSString *isDaily;// (string, optional): 每日一练:Y, 其他为N ,
@property (nonatomic, copy) NSString *isTest;// (string, optional): 1: 模考大赛，0：其他 ,
@property (nonatomic, assign) NSInteger modelId;// (integer, optional): 模块id ,
@property (nonatomic, copy) NSString *sort;// (string, optional): 展示顺序 ,
@property (nonatomic, copy) NSString *title;// (string, optional): 标题 ,
@property (nonatomic, copy) NSString *type;// (string, optional): 类型 1:题库，2：直播，3：录播，4：狮享等等
@end

@interface BLMyRecordTypeModel : NSObject
@property (nonatomic, copy) NSString *content;// (string, optional): 内容 ,
@property (nonatomic, copy) NSArray <BLMyRecordTypeDotsModel *>*functionTypeErrorDTOS;//(Array[KylinIndexFunctionTypeErrorDTO], optional): 题模块功能类型 ,
@property (nonatomic, assign)NSInteger modelid;// (integer, optional): id ,
@property (nonatomic, copy) NSString *img;// (string, optional): 图片 ,
@property (nonatomic, copy) NSString *sort;// (string, optional): 展示顺序 ,
@property (nonatomic, copy) NSString *title;// (string, optional): 标题
@end

@interface BLMyRecordDTOListModel : NSObject

@property (nonatomic, copy)   NSString *isFree;
@property (nonatomic, copy)   NSString *isRare;
@property (nonatomic, copy)   NSString *title; //
@property (nonatomic, assign) NSInteger total; //
@property (nonatomic, assign) NSInteger status; // 是否完成 1: 已完成， 2：未完成
@property (nonatomic, copy)   NSString *duration;
@property (nonatomic, strong) NSString *completeTime; // 完成时间
@property (nonatomic, copy)   NSString *isManual;
@property (nonatomic, copy) NSString *score; // 分数
@property (nonatomic, assign) NSInteger functionTypeId;
@property (nonatomic, strong) NSString *coverImg;
@property (nonatomic, copy)   NSString *isPurchase;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger salesNum;
@property (nonatomic, assign) NSInteger modelid;
@property (nonatomic, assign) NSInteger setRecordId;
@property (nonatomic, assign) NSInteger doneCount; //已做
@property (nonatomic, assign) NSInteger originPrice;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, assign) NSInteger useDuration; //用时
@property (nonatomic, copy)   NSString *isPurchaseRare;
@property (nonatomic, assign) NSInteger price;

@property (nonatomic, assign) NSInteger setRecId;

@end


@interface BLMyRecordInfoModel : NSObject
@property (nonatomic, copy) NSString *content;// (string, optional): 内容 ,
@property (nonatomic, copy) NSArray <BLMyRecordInfoModel *>*functionTypeDTOList;//(Array[KylinIndexFunctionTypeErrorDTO], optional): 题模块功能类型 ,
@property (nonatomic, copy) NSArray <BLMyRecordDTOListModel *>*setRecordDTOList;//(Array[KylinIndexFunctionTypeErrorDTO], optional): 题模块功能类型 ,

@property (nonatomic, assign)NSInteger modelid;// (integer, optional): id ,
@property (nonatomic, copy) NSString *img;// (string, optional): 图片 ,
@property (nonatomic, copy) NSString *sort;// (string, optional): 展示顺序 ,
@property (nonatomic, copy) NSString *title;// (string, optional): 标题
@property (nonatomic, assign)NSInteger functionId;// (integer, optional): id
@property (nonatomic, assign) BOOL isPull; //是否展开
@property (readonly) NSInteger questionNum; //


@end





NS_ASSUME_NONNULL_END
