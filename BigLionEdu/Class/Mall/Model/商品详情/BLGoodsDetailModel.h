//
//  BLGoodsDetailModel.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/21.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYText.h>
#import "BLGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@class BLGoodsDetailGroupModel,BLGoodsDetailVideoModel,BLGoodsDetailSXModel,BLGoodsDetailBannerModel;

//
//"id": 26,
//"modelId": 12,
//"memberId": null,
//"title": "计算机起源百科ABC123",
//"price": 120,
//"coverImg": "file20190918100651.jpg",
//"salesNum": 100,
//"isRecommend": "1",
//"discountTypePick": null,
//"type": "0",
//"typeId": null,
//"labelId": 1,
//"labelName": null,
//"bookIntroduce": "书籍详情介绍富文本",
//"catalog": "书籍目录富文本"

@interface BLGoodsDetailModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *originPrice;
@property (nonatomic, copy) NSString *coverImg;
@property (nonatomic, copy) NSString *salesNum;
@property (nonatomic, copy) NSString *isRecommend;
@property (nonatomic, copy) NSString *discountTypePick;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, copy) NSString *labelId;
@property (nonatomic, copy) NSString *labelName;
@property (nonatomic, copy) NSString *bookIntroduce;
@property (nonatomic, copy) NSString *catalog;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *groupRule;
//拼团团长价格
@property (nonatomic, strong) NSNumber *provoterPrice;
//参团团员价格
@property (nonatomic, strong) NSNumber *memberPrice;

//是否拼团
@property (nonatomic, assign) NSInteger isGroup;

@property (nonatomic, strong) NSMutableAttributedString *bookIntroduceAttr;
@property (nonatomic, strong) NSMutableAttributedString *catalogAttr;
@property (nonatomic, assign) CGFloat bookIntroduceHeight;
@property (nonatomic, assign) CGFloat catalogHeight;
@property (nonatomic, copy) dispatch_block_t refreshHandler;

//商品已开团列表
@property (nonatomic, copy) NSArray <BLGoodsDetailGroupModel *>*groupLists;
//赠送的视频
@property (nonatomic, copy) NSArray <BLGoodsDetailVideoModel *>*goodsInfoList;
//推荐的商品
@property (nonatomic, copy) NSArray <BLGoodsModel *>*goodsList;
//推荐的狮享
@property (nonatomic, copy) NSArray <BLGoodsDetailSXModel *>*tutorDTOS;

@property (nonatomic, copy) NSArray <BLGoodsDetailBannerModel *>*goodsBannerList;
@property (nonatomic, copy) NSArray <NSString *>*goodsBannerUrlList;

@end

/**
 * 拼团
 */
@interface BLGoodsDetailGroupModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *needMemberNum;
@property (nonatomic, copy) NSString *groupType;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *provoterPrice;
@property (nonatomic, copy) NSString *memberPrice;

@property (nonatomic, assign) BOOL isEnd;

@end

/**
 * 赠送的视频
 */
@interface BLGoodsDetailVideoModel : NSObject

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy) NSString *infoId;
@property (nonatomic, copy) NSString *recId;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *courseHour;
@property (nonatomic, copy) NSString *salesNum;
@property (nonatomic, copy) NSString *tutorImg;
@property (nonatomic, copy) NSString *tutorName;
@property (nonatomic, copy) NSString *label;

@end

/**
 * 推荐狮享
 */
@interface BLGoodsDetailSXModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *tutorTitle;
@property (nonatomic, copy) NSString *desc;

@end

/**
 * banner
 */
@interface BLGoodsDetailBannerModel : NSObject

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *goodsId;

@end


NS_ASSUME_NONNULL_END
