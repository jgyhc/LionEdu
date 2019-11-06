//
//  BLOrderSurePayWayTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGoodsSureModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLOrderSurePayWayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;
@property (nonatomic, strong) BLGoodsSurePayWayModel *model;

@end

NS_ASSUME_NONNULL_END
