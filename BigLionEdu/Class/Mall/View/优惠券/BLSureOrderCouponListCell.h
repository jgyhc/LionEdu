//
//  BLSureOrderCouponListCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/23.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGoodsSureModel.h"

@protocol BLSureOrderCouponListCellDelegate <NSObject>

- (void)BLSureOrderCouponListCellDidSelected:(BLGoodsSureCouponModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLSureOrderCouponListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rmb;
@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic, strong) BLGoodsSureCouponModel *model;
@property (nonatomic, weak) id <BLSureOrderCouponListCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
