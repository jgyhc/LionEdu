//
//  BLGoodsDetailHeader.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/11.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLGoodsDetailHeaderDelegate <NSObject>

- (void)BLGoodsDetailHeaderViewDetail;
- (void)BLGoodsDetailHeaderCatalogue;
- (void)BLGoodsDetailHeaderRecommend;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLGoodsDetailHeader : UIView

@property (nonatomic, strong) NSNumber *model;
@property (nonatomic, strong) UIButton *recommendButton;
//1详情 2目录 3推荐
- (void)bl_selectToIndex:(NSInteger)index;
@property (nonatomic, weak) id <BLGoodsDetailHeaderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
