//
//  BLMealBannerTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/13.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BLMealBannerTableViewCellDelegate <NSObject>

- (void)bannerDidChangeIndex:(NSInteger)index;

@end

typedef void(^MealBannerTableViewCellClickBlock)(NSInteger index);

@interface BLMealBannerTableViewCell : UITableViewCell
@property (nonatomic,strong)NSArray *model;
@property (nonatomic ,assign) MealBannerTableViewCellClickBlock clickBlock;
@property (nonatomic, weak) id<BLMealBannerTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
