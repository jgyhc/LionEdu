//
//  BLCouponViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "LCAlertController.h"

NS_ASSUME_NONNULL_BEGIN
//定义枚举类型
typedef enum {
    exChangeSuccess  = 0,
    scan
}CouponViewAlertAction;

@interface BLCouponViewController : LCAlertController
typedef void (^BLCouponViewControllerActionBlock) (CouponViewAlertAction action);

@property (nonatomic, copy) BLCouponViewControllerActionBlock actionBlock;
@end

NS_ASSUME_NONNULL_END
