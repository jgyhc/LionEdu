//
//  BLQuestionBankMockViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLQuestionBankMockViewController : UIViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger functionTypeId;

@property (nonatomic, strong) UIViewController *superViewController;
@end

NS_ASSUME_NONNULL_END
