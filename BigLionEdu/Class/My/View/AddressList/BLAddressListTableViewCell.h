//
//  BLAddressListTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLAddressModel.h"

@protocol BLAddressListTableViewCellDelegate <NSObject>

- (void)BLAddressListTableViewCellEdit:(BLAddressModel *)model;
- (void)BLAddressListTableViewCellDelete:(BLAddressModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLAddressListTableViewCell : UITableViewCell

@property (nonatomic, strong) BLAddressModel * model;
@property (nonatomic, assign) id <BLAddressListTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
