//
//  BLOrderSureCouponsTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGoodsSureModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLOrderSureCouponsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (nonatomic, strong) BLGoodsSureConfirmModel *model;

@end

NS_ASSUME_NONNULL_END
