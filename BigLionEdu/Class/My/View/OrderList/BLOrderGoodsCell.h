//
//  BLOrderGoodsCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLOrderModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface BLOrderGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (nonatomic, strong) BLOrderGoodsModel *model;

@end

NS_ASSUME_NONNULL_END
