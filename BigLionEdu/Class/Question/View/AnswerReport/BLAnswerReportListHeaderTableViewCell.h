//
//  BLAnswerReportListHeaderTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLAnswerReportQuestionListModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLAnswerReportListHeaderTableViewCellDelegate <NSObject>

- (void)selectTypeWithModel:(BLAnswerReportQuestionListModel *)model;

@end

@interface BLAnswerReportListHeaderTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BLAnswerReportListHeaderTableViewCellDelegate>delegate;

@property (nonatomic, weak) NSArray<BLAnswerReportQuestionListModel *> *model;
@end

NS_ASSUME_NONNULL_END
