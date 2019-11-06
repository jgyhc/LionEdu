//
//  BLOffLineVideoEditCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLClassScheduleItemModel.h"

@protocol BLOffLineVideoEditCellDelegate <NSObject>

- (void)BLOffLineVideoEditCellDidChange;

@end
NS_ASSUME_NONNULL_BEGIN

@interface BLOffLineVideoEditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, strong) BLClassScheduleItemModel *model;
@property (nonatomic, weak) id <BLOffLineVideoEditCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
