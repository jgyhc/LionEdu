//
//  BLHeadlinesItemTableViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/12.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLNewsListModel.h"
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLHeadlinesItemTableViewController : UITableViewController<JXCategoryListContentViewDelegate>

//@property (nonatomic, strong) BLNewsListModel *model;

@property (nonatomic, strong) UIViewController *superViewController;

@property (nonatomic, assign) NSInteger typeId;
@end

NS_ASSUME_NONNULL_END
