//
//  BLTrainListShareTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/17.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLCurriculumModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainListShareTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon_bg;
@property (weak, nonatomic) IBOutlet UILabel *icon_txt;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (nonatomic, strong) BLCurriculumModel *model;


@end

NS_ASSUME_NONNULL_END
