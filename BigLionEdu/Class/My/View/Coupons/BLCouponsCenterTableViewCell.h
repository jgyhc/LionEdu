//
//  BLCouponsCenterTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/29.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyCouponsItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLCouponsCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *MoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *explainBtn;
@property (nonatomic, weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (nonatomic,strong)BLMyCouponslistModel *model;
@end

NS_ASSUME_NONNULL_END
