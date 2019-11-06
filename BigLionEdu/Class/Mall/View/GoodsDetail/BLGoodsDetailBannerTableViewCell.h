//
//  BLGoodsDetailBannerTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>
#import "BLGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLGoodsDetailBannerTableViewCell : UITableViewCell<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bannerContainer;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (nonatomic, strong) SDCycleScrollView *bannerScrollView;
@property (nonatomic, strong) BLGoodsDetailModel *model;

@end

NS_ASSUME_NONNULL_END
