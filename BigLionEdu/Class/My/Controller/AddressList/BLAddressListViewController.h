//
//  BLAddressListViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLAddressListViewController : UIViewController
/** 当前选中的地址id */
@property (nonatomic, assign) NSInteger addressId;

@property (nonatomic, copy) void (^didSelectAddressBlock)(NSDictionary *address);

@end

NS_ASSUME_NONNULL_END
