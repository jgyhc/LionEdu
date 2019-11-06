//
//  BLRecordItemTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLRecordItemTableViewCell : UITableViewCell

@property (nonatomic, strong) BLMyRecordDTOListModel *model;

@end

NS_ASSUME_NONNULL_END
