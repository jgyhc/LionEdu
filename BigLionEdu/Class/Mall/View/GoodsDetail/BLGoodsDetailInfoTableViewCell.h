//
//  BLGoodsDetailInfoTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLGoodsDetailInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *oPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *saleAndStoreLab;
@property (weak, nonatomic) IBOutlet UIButton *joinGroupBtn;

@property (nonatomic, strong) BLGoodsDetailModel *model;

@end

NS_ASSUME_NONNULL_END
