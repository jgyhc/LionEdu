//
//  BLCoreQuestionSetsModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLCoreQuestionSetsModel : NSObject

/** 是否免费 */
@property (nonatomic, copy)   NSString *isFree;

/** 大于等于该等级的可以免费试用 */
@property (nonatomic, strong) NSNumber * levelId;

/** 是否稀罕：1:稀罕， 0：不是 */
@property (nonatomic, copy)   NSString *isRare;

/** 省 */
@property (nonatomic, copy)   NSString *province;

/** 市 */
@property (nonatomic, copy)   NSString *city;

/** 区 */
@property (nonatomic, copy)   NSString *area;

/** 试卷标题 */
@property (nonatomic, copy)   NSString *title;

/** 试卷总题数 */
@property (nonatomic, strong) NSNumber * total;

/** 整套试题时间 */
@property (nonatomic, copy)   NSString *duration;

/** 是否需要人工干预 1.是 0.否 */
@property (nonatomic, copy)   NSString *isManual;

/**  */
@property (nonatomic, copy)   NSString *updateTime;

/** 功能类型id */
@property (nonatomic, strong) NSNumber * functionTypeId;

/**  封面（商城） */
@property (nonatomic, copy)   NSString *coverImg;

/**  */
@property (nonatomic, copy)   NSString *delFlag;

/**  年份 */
@property (nonatomic, copy)   NSString *year;


@property (nonatomic, copy)   NSString *endDate;

/** 类型 */
@property (nonatomic, copy)   NSString *type;

/** 购买过后有效期/天 */
@property (nonatomic, strong) NSNumber * validDay;


@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSNumber * createBy;
@property (nonatomic, strong) NSNumber * updateBy;


@property (nonatomic, copy)   NSString *startDate;
@property (nonatomic, copy)   NSString *createTime;

/** 价格 */
@property (nonatomic, strong) NSNumber * price;


@end

NS_ASSUME_NONNULL_END
