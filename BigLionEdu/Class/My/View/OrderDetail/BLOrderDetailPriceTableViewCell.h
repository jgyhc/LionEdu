//
//  BLOrderDetailPriceTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLOrderDetailPriceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *expressPriceLab;

@property (nonatomic, strong) BLOrderModel *model;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;

@end

NS_ASSUME_NONNULL_END
