//
//  BLMyInterestItemsTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/24.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyInterestItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLMyInterestItemsTableViewCellDelegate <NSObject>

- (void)updateTableViewWithModel:(BLInterestInfoModel *)model;

@end

@interface BLMyInterestItemsTableViewCell : UITableViewCell

@property (nonatomic, weak) id <BLMyInterestItemsTableViewCellDelegate> delegate;
@property (nonatomic ,strong) BLMyInterestItemModel *model;
@end

NS_ASSUME_NONNULL_END
