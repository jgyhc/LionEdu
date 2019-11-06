//
//  BLPaperModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLPaperModel : NSObject

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, copy)   NSString *coverImg;
@property (nonatomic, assign) NSInteger salesNum;
@property (nonatomic, copy)   NSString *isManual;
@property (nonatomic, assign) NSInteger originPrice;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, assign) NSInteger functionTypeId;

/** 是否稀罕：1:稀罕， 0：不是 */
@property (nonatomic, copy)   NSString *isRare;

/** 是否购买 1.是 0否 */
@property (nonatomic, copy)   NSString *isPurchase;
@property (nonatomic, copy)   NSString *duration;
@property (nonatomic, assign) NSInteger doneCount;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, copy)   NSString *isFree;

@property (nonatomic, assign) long startEffectiveTime;

@property (nonatomic, assign) long endEffectiveTime;

/** 是否是预售的卷子 */
@property (nonatomic, copy) NSString *isAdvance;

/** 预约卷子   开始答题时间 */
@property (nonatomic, copy) NSString *advanceDate;

//是否已经开始预售了
@property (nonatomic, assign) BOOL isStart;

//是否已经全部购买
@property (nonatomic, assign) BOOL isAllBuy;

/** 是否购买稀罕：1:是， 0：否 */
@property (nonatomic, copy) NSString *isPurchaseRare;

@property (nonatomic, copy) NSString *startEffectiveTimeString;

@property (nonatomic, copy) NSString *endEffectiveTimeString;



@property (nonatomic, strong) NSMutableAttributedString *titleAttributeString;

@property (nonatomic, strong) NSAttributedString *tagAttributeString;

@property (nonatomic, strong) NSMutableAttributedString *titleContentAttributeString;

@end

NS_ASSUME_NONNULL_END
