//
//  BLTrainShareDetailCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTrainCurriculumDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainShareDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (nonatomic, strong) BLTrainCurriculumDetailModel *model;

@end

NS_ASSUME_NONNULL_END
