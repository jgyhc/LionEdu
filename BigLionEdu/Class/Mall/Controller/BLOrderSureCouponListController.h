//
//  BLOrderSureCouponListController.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/23.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGoodsSureModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLOrderSureCouponListController : UIViewController

@property (nonatomic, strong) BLGoodsSureConfirmModel *model;
@property (nonatomic, copy) dispatch_block_t didSelectedCouponHandler;

@end

NS_ASSUME_NONNULL_END
