//
//  BLMealFailureTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/13.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyMealModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLMealFailureTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *buyTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (nonatomic, strong)BLMyMyMealModel *model;
@end

NS_ASSUME_NONNULL_END
