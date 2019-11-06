//
//  BLTopicMaterialImageTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTopicImageModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BLTopicMaterialImageTableViewCellDelegate <NSObject>

- (void)updateCellHeightWithCell:(UITableViewCell *)tableViewCell model:(BLTopicImageModel *)model cellHeight:(CGFloat)cellHeight;

@end

@interface BLTopicMaterialImageTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BLTopicMaterialImageTableViewCellDelegate> delegate;

@property (nonatomic, strong) BLTopicImageModel * model;

@property (nonatomic, strong) NSIndexPath * indexPath;

@end

NS_ASSUME_NONNULL_END
