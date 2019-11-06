//
//  BLMallIndexCollectionViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGoodsModel.h"

@protocol BLMallIndexCollectionViewCellDelegate <NSObject>

- (void)BLMallIndexCollectionViewCellDidSelect:(BLGoodsModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLMallIndexCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) BLGoodsModel * model;
@property (nonatomic, weak) id <BLMallIndexCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
