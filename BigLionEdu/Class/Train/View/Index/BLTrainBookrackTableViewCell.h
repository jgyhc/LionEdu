//
//  BLTrainBookrackTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLRecommendBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLTrainBookrackTableViewCellDelegate <NSObject>

- (void)handlerBookrackDetail:(BLTrainCoreDoodsListModel *)model;

- (void)handlerJumpShelfDetails;

@end

@interface BLTrainBookrackTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BLTrainBookrackTableViewCellDelegate> delegate;

@property (nonatomic, strong) BLRecommendBookModel *model;

@end

NS_ASSUME_NONNULL_END
