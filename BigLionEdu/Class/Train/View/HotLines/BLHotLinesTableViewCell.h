//
//  BLHotLinesTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/12.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLNewsDTOListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLHotLinesTableViewCell : UITableViewCell
@property (nonatomic, strong) BLNewsDTOListModel *model;
@end

NS_ASSUME_NONNULL_END
