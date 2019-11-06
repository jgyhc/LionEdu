//
//  BLTrainViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/21.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainViewController : UIViewController
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, assign) BOOL isNeedIndicatorPositionChangeItem;

@property (nonatomic, assign) BOOL shouldHandleScreenEdgeGesture;


- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index;


@property (nonatomic, assign) NSInteger selectIndex;
@end

NS_ASSUME_NONNULL_END
