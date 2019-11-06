//
//  BLOrderDetailAddressTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLOrderDetailAddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (nonatomic, strong) BLOrderModel *model;

@end

NS_ASSUME_NONNULL_END
