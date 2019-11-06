//
//  BLCouponsFailureTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/29.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyCouponsItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLCouponsFailureTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *MoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *desBtn;
@property (nonatomic)BLMyCouponslistModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@end

NS_ASSUME_NONNULL_END
