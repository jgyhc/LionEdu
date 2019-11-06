//
//  BLTrainAudioHeaderView.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/26.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTrainCurriculumDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainAudioHeaderView : UIView

@property (strong, nonatomic)  UIButton *playBtn;
@property (strong, nonatomic)  UIButton *prevBtn;
@property (strong, nonatomic)  UIButton *nextBtn;
@property (strong, nonatomic)  UIButton *speed;
@property (strong, nonatomic)  UIImageView *photo;
@property (strong, nonatomic)  UIButton *sxk;
@property (strong, nonatomic)  UISlider *process;
@property (nonatomic, strong) BLTrainCurriculumDetailModel *model;

@end

NS_ASSUME_NONNULL_END
