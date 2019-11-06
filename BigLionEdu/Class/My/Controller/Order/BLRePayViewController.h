//
//  BLRePayViewController.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/7.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLRePayViewController : UIViewController

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) NSInteger singleType;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) NSInteger functionTypeId;

@property (nonatomic, assign) NSInteger isBuyPackage;


@end

NS_ASSUME_NONNULL_END
