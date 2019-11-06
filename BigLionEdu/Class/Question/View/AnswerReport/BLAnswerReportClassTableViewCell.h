//
//  BLAnswerReportClassTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLAnswerReportQuestionListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLAnswerReportClassTableViewCell : UITableViewCell

@property (nonatomic, strong) BLAnswerReportQuestionItemModel * model;

@end

NS_ASSUME_NONNULL_END
