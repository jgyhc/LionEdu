//
//  BLMockDetailTopTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMockItemModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BLMockDetailTopTableViewCellDelegate <NSObject>

- (void)signUpWithModel:(BLMockItemModel *)model;

@end

@interface BLMockDetailTopTableViewCell : UITableViewCell

@property (nonatomic, strong) BLMockItemModel *model;

@property (nonatomic, weak) id<BLMockDetailTopTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
