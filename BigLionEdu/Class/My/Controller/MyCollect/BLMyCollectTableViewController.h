//
//  BLMyCollectTableViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMyCollectTableViewController : UITableViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger modelID;

@end

NS_ASSUME_NONNULL_END
