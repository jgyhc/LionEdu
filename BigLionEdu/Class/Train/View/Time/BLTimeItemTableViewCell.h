//
//  BLTimeItemTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/17.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTimeItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLTimeItemTableViewCell : UITableViewCell
@property (nonatomic, strong) BLTimeItemModel *model;
@end

NS_ASSUME_NONNULL_END
