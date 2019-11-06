//
//  BLQuestionListTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLQuestionsClassificationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLQuestionListTableViewCell : UITableViewCell

@property (nonatomic, strong) BLQuestionsClassificationModel * model;

@end

NS_ASSUME_NONNULL_END
