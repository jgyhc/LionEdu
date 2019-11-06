//
//  BLOrderSureAddressTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLOrderSureAddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (nonatomic, strong) BLAddressModel *model;

@end

NS_ASSUME_NONNULL_END
