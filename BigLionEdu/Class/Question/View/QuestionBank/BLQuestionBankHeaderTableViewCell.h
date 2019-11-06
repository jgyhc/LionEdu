//
//  BLQuestionBankHeaderTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/25.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLQuestionsClassificationModel;

@protocol BLQuestionBankHeaderTableViewCellDelegate <NSObject>

- (void)BLQuestionBankHeaderTableViewCellSelect:(BLQuestionsClassificationModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLQuestionBankHeaderTableViewCell : UITableViewCell

@property (nonatomic, strong) BLQuestionsClassificationModel * model;
@property (nonatomic, weak) id <BLQuestionBankHeaderTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
