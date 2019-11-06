//
//  BLMockDetailButtonTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMockItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLMockDetailButtonTableViewCellDelegate <NSObject>

- (void)didSelectButtonWithModel:(BLMockItemModel *)model;

@end
@interface BLMockDetailButtonTableViewCell : UITableViewCell
@property (nonatomic, strong) BLMockItemModel *model;

@property (nonatomic, weak) id<BLMockDetailButtonTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
