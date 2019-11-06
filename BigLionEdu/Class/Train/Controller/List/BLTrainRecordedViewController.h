//
//  BLTrainRecordedViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN
//录播
@interface BLTrainRecordedViewController : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, strong) UIViewController *superViewController;
@property (nonatomic, strong) NSArray * functionTypeDTOList;
@property (nonatomic, assign) NSInteger functionTypeId;
@property (nonatomic, assign) NSInteger modelId;


/// 搜索的时候用到
@property (nonatomic, strong) UIColor *categoryTitleViewBackgroundColor;

/// 搜索的时候用到
@property (nonatomic, copy) NSString *searchStr;

@end

NS_ASSUME_NONNULL_END
