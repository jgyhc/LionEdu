//
//  BLTrainShareInfoCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTrainCurriculumDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainShareInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *prevBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *speed;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIButton *sxk;
@property (weak, nonatomic) IBOutlet UISlider *process;
@property (nonatomic, strong) BLTrainCurriculumDetailModel *model;

@end



NS_ASSUME_NONNULL_END
