//
//  BLMistakesHeaderTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyMistakeModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLMistakesHeaderTableViewCellDelegate <NSObject>

- (void)or_celldidChangeSelected;

@end



@interface BLMistakesHeaderTableViewCell : UITableViewCell

@property (nonatomic, strong) BLMyMistakeModel * model;

@property (nonatomic, assign) id<BLMistakesHeaderTableViewCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
