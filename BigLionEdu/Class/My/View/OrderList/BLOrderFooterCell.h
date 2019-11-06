//
//  BLOrderFooterCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol BLOrderFooterCellDelegate <NSObject>

- (void)bl_delete:(BLOrderModel *)model;
- (void)bl_cancel:(BLOrderModel *)model;
- (void)bl_viewDetail:(BLOrderModel *)model;
- (void)bl_backMoney:(BLOrderModel *)model;
- (void)bl_toPay:(BLOrderModel *)model;

@end

@interface BLOrderFooterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) BLOrderModel *model;
@property (nonatomic, weak) id <BLOrderFooterCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
