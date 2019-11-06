//
//  BLTrainSubTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/20.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTrainBaseTitleModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLTrainSubTableViewCellDelegate <NSObject>

- (void)updateEventWithIndex:(NSInteger)index model:(BLTrainBaseTitleModel *)model;


- (void)didSelectAllEvent:(NSInteger)index;
@end

@interface BLTrainSubTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray<BLTrainBaseTitleModel *> *model;

@property (nonatomic, weak) id<BLTrainSubTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
