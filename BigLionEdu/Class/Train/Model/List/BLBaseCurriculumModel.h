//
//  BLBaseCurriculumModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/** functionId (integer, optional): 功能Id ,
 functionType (integer, optional): 1: 题库， 0：课程， 2： 商城， 3： 面试 等等 ,
 functionTypeDTOList (Array[ResponseAllFunctionTypeDTO], optional): 模块功能类型 ,
 id (integer, optional): 模块功能类型id ,
 isFree (string, optional): 是否免费 1.是 0.否 ,
 modelId (integer, optional): 模块id ,
 parentId (integer, optional): 上级id ,
 title (string, optional): 标题 ,
 type (integer, optional): 1:题库，2：直播，3：录播，4：狮享，5：面授等等 */
@interface BLBaseCurriculumModel : NSObject
@property (nonatomic, copy)   NSString *isFree;
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, assign) NSInteger functionType;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) NSInteger functionId;
@property (nonatomic, strong) NSArray<BLBaseCurriculumModel *> *functionTypeDTOList;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy)   NSString *advanceDate;
@property (nonatomic, assign) NSInteger doingNum;
@property (nonatomic, assign) NSInteger topPid;
@property (nonatomic, copy)   NSString *allParentId;
@property (nonatomic, copy)   NSString *isRare;
@property (nonatomic, copy)   NSString *img;
@property (nonatomic, assign) NSInteger setNum;
@property (nonatomic, copy)   NSString *sort;
@property (nonatomic, assign) NSInteger endEffectiveTime;
@property (nonatomic, copy)   NSString *isPurchase;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, copy)   NSString *isAdvance;
@property (nonatomic, assign) NSInteger validDay;
@property (nonatomic, assign) NSInteger advanceDateLong;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, copy)   NSString *isDaily;
@property (nonatomic, strong) NSString *labelName;
@property (nonatomic, copy)   NSString *introduction;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, copy)   NSString *isTest;
@property (nonatomic, assign) NSInteger startEffectiveTime;


@end

NS_ASSUME_NONNULL_END
