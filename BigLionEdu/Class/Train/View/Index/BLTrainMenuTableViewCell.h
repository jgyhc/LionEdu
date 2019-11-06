//
//  BLTrainMenuTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTrainIndexFunctionsModel.h"


NS_ASSUME_NONNULL_BEGIN
@protocol BLTrainMenuTableViewCellDelegate <NSObject>

- (void)didSelectMenuWithModel:(BLTrainIndexFunctionsModel *)model;

@end

@interface BLTrainMenuTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray<BLTrainIndexFunctionsModel *> * model;

@property (nonatomic, weak) id<BLTrainMenuTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
