//
//  BLGoodsDetailHeaderViewCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/9.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLGoodsDetailHeaderViewCellDelegate <NSObject>

- (void)BLGoodsDetailHeaderViewCellDetail;
- (void)BLGoodsDetailHeaderViewCellCatalogue;
- (void)BLGoodsDetailHeaderViewCellRecommend;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLGoodsDetailHeaderViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIButton *catalogueButton;
@property (nonatomic, strong) UIButton *recommendButton;

@property (nonatomic, strong) NSMutableDictionary *model;
//1详情 2目录 3推荐
- (void)bl_selectToIndex:(NSInteger)index;
@property (nonatomic, weak) id <BLGoodsDetailHeaderViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
