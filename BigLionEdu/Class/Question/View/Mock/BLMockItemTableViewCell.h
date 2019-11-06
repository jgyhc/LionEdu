//
//  BLMockItemTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMockItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLMockItemTableViewCell : UITableViewCell

@property (nonatomic, strong) BLMockItemModel * model;

@end

NS_ASSUME_NONNULL_END
