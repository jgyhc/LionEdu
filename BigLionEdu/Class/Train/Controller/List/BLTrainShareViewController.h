//
//  BLTrainShareViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/17.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainShareViewController : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, strong) UIViewController *superViewController;

@property (nonatomic, assign) NSInteger functionTypeId;

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
