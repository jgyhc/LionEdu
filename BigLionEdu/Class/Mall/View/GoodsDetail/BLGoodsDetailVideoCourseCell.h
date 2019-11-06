//
//  BLGoodsDetailVideoCourseCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/5.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLGoodsDetailVideoCourseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *jp_bg;
@property (weak, nonatomic) IBOutlet UILabel *jp;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *saleLab;
@property (weak, nonatomic) IBOutlet UIImageView *courseImg;
@property (weak, nonatomic) IBOutlet UIImageView *online_bg;
@property (weak, nonatomic) IBOutlet UILabel *onlineLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (nonatomic, strong) BLGoodsDetailVideoModel *model;

@end

NS_ASSUME_NONNULL_END
