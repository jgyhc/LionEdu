//
//  BLQuestionBankTableViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/25.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLQuestionBankTableViewController : UITableViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger parentId;

@property (nonatomic, strong) UIViewController *superViewController;

@property (nonatomic, strong) NSDictionary *screenParams;

@property (nonatomic, copy) NSString *searchTitle;

@property (nonatomic, copy) NSString * years;

@property (nonatomic, copy) NSString * startYears;

@property (nonatomic, copy) NSString * endYears;

@property (nonatomic, copy) NSString * province;

@property (nonatomic, copy) NSString * city;

@property (nonatomic, copy) NSString * area;

- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
