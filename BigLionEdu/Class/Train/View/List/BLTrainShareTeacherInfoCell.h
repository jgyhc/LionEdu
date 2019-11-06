//
//  BLTrainShareTeacherInfoCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTrainCurriculumDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLTrainShareTeacherInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (nonatomic, strong) BLTrainShareDetailTutorModel *model;

@end

NS_ASSUME_NONNULL_END
