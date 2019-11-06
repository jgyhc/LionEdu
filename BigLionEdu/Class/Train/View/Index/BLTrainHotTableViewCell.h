//
//  BLTrainHotTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTrainCoreNewsModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol BLTrainHotTableViewCellDelegate <NSObject>

- (void)didSelectHot:(BLTrainCoreNewsModel *)model;

@end

@interface BLTrainHotTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray<BLTrainCoreNewsModel *> * model;

@property (nonatomic, weak) id<BLTrainHotTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
