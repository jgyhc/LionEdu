//
//  BLTrainContentViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/21.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainContentViewController : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
