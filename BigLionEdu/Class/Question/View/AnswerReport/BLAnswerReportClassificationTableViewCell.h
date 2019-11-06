//
//  BLAnswerReportClassificationTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLAnswerReportModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLAnswerReportClassificationTableViewCellDelegate <NSObject>

- (void)leftEvent;

- (void)rightEvent;

- (void)centerEvent;

@end

@interface BLAnswerReportClassificationTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BLAnswerReportClassificationTableViewCellDelegate> delegate;

@property (nonatomic, strong) BLAnswerReportModel * model;
@end

NS_ASSUME_NONNULL_END
