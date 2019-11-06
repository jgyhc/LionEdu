//
//  BLGoodsDetailHeaderView.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLGoodsDetailHeaderViewDelegate <NSObject>

- (void)BLGoodsDetailHeaderViewViewDetail;
- (void)BLGoodsDetailHeaderViewViewCatalogue;
- (void)BLGoodsDetailHeaderViewViewRecommend;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLGoodsDetailHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSNumber *model;
@property (nonatomic, weak) id <BLGoodsDetailHeaderViewDelegate> delegate;
- (void)bl_selectToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
