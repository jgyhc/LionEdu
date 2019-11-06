//
//  BLTopicAnalysisVideoContentTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/20.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTopicVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@class BLTopicAnalysisVideoContentTableViewCell;
@protocol BLTopicAnalysisVideoContentTableViewCellDelegate <NSObject>

- (void)tappedCoverOnTheTableViewCell:(BLTopicAnalysisVideoContentTableViewCell *)cell model:(BLTopicVideoModel *)model;

@end
@interface BLTopicAnalysisVideoContentTableViewCell : UITableViewCell

@property (nonatomic, strong) BLTopicVideoModel * model;

@property (nonatomic, weak) id<BLTopicAnalysisVideoContentTableViewCellDelegate> delegate;
@end


NS_ASSUME_NONNULL_END
