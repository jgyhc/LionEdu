//
//  BLOffLineVideoCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLClassScheduleItemModel.h"
@class FKTask;

@protocol BLOffLineVideoCellDelegate <NSObject>

- (void)BLOffLineVideoCellPush:(BLClassScheduleItemModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLOffLineVideoCell : UITableViewCell

@property (nonatomic, strong) FKTask *task;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) BLClassScheduleItemModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *playIcon;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic, weak) id <BLOffLineVideoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
