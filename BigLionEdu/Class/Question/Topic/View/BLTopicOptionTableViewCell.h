//
//  BLTopicOptionTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTopicOptionModel.h"

NS_ASSUME_NONNULL_BEGIN
@class BLTopicOptionTableViewCell;
@protocol BLTopicOptionTableViewCellDelegate <NSObject>

- (void)updateCellHeight:(CGFloat)cellHeight cell:(BLTopicOptionTableViewCell *)cell;

@end

@interface BLTopicOptionTableViewCell : UITableViewCell

@property (nonatomic, strong) BLTopicOptionModel * model;

@property (nonatomic, weak) id delegate;

@end

NS_ASSUME_NONNULL_END
