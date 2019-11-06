//
//  BLOrderDetailLogisticsTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLOrderDetailLogisticsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (nonatomic, strong) BLOrderModel *model;

@end

NS_ASSUME_NONNULL_END
