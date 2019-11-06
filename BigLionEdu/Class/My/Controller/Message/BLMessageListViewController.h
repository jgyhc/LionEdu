//
//  BLMessageListVC.h
//  BigLionEdu
//
//  Created by sunmaomao on 2019/9/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMessageListViewController : UITableViewController

@property (nonatomic, assign)NSInteger messageTypeId;
@property (nonatomic, copy) NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
