//
//  BLTrainSearchItemTableViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface BLTrainSearchItemTableViewController : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, copy) NSString *searchTitle;

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger functionTypeId;

@end

NS_ASSUME_NONNULL_END
