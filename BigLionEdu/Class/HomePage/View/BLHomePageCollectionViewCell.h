//
//  BLHomePageCollectionViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLHomePageItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLHomePageCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) BLHomePageItemModel *model;
@end

NS_ASSUME_NONNULL_END
