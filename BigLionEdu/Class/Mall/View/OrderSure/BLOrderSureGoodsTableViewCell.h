//
//  BLOrderSureGoodsTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGoodsSureModel.h"
#import "BLPaperModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLOrderSureGoodsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *flag;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (nonatomic, strong) id model;

@end

NS_ASSUME_NONNULL_END
