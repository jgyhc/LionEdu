//
//  BLQuestionListTableViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLQuestionListTableViewController : UITableViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, strong) UIViewController *superViewController;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, assign) NSInteger parentId;

@property (nonatomic, strong) NSArray *list;
@end

NS_ASSUME_NONNULL_END
