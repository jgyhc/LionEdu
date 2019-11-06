//
//  BLCouponsTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/29.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyCouponsItemModel.h"

@protocol BLCouponsTableViewCellDelegate <NSObject>

- (void)toUserCoupons;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLCouponsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *MoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *desBtn;
@property (nonatomic, strong) BLMyCouponslistModel *model;
@property (nonatomic, weak) id <BLCouponsTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
