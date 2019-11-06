//
//  BLOrderSureDistributionTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGoodsSureModel.h"
#import "BLPaperModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLOrderSureDistributionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (nonatomic, strong) id model;

@end

NS_ASSUME_NONNULL_END
