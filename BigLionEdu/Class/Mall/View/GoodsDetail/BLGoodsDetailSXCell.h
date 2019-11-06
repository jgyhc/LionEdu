//
//  BLGoodsDetailSXCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/8.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLGoodsDetailSXCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *viewNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *flag;
@property (weak, nonatomic) IBOutlet UILabel *flagText;
@property (nonatomic, strong) BLGoodsDetailSXModel *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

NS_ASSUME_NONNULL_END
