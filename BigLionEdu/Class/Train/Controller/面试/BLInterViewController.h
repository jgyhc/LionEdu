//
//  BLInterViewController.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/8.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLInterViewController : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, strong) UIViewController *superViewController;

@end

NS_ASSUME_NONNULL_END
