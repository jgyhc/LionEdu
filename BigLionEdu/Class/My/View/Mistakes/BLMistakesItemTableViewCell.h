//
//  BLMistakesItemTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyMistakeModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLMistakesItemTableViewCellDelegate <NSObject>

- (void)or_celldidChangeSelected;

@end


@interface BLMistakesItemTableViewCell : UITableViewCell

@property (nonatomic, strong) BLMyMistakeQuestionModel * model;

@property (nonatomic, weak) id<BLMistakesItemTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
