//
//  BLOrderListTableViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLOrderListTableViewController : UITableViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, strong) UIViewController *superViewController;

//订单状态(1：待付款，2：待发货，3：待收货，4：退款中，5：交易关闭，6：交易成功，7：交易失败)
@property (nonatomic, copy) NSString *status;

@end

NS_ASSUME_NONNULL_END
