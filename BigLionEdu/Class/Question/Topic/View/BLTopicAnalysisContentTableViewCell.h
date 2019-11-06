//
//  BLTopicAnalysisContentTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTopicModel.h"
#import "BLTopicTextModel.h"

NS_ASSUME_NONNULL_BEGIN
@class BLTopicAnalysisContentTableViewCell;
@protocol BLTopicAnalysisContentTableViewCellDelegate <NSObject>

- (void)updateCellHeight:(CGFloat)height cell:(BLTopicAnalysisContentTableViewCell *)cell;

@end

@interface BLTopicAnalysisContentTableViewCell : UITableViewCell

@property (nonatomic, strong) BLTopicTextModel *model;

@property (nonatomic, weak) id<BLTopicAnalysisContentTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
