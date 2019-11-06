//
//  BLOrderHeaderCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLOrderHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLa;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) BLOrderModel *model;

@end

NS_ASSUME_NONNULL_END
