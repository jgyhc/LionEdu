//
//  BLTrainExamPaperViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/24.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainExamPaperViewController : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger parentId;
@end

NS_ASSUME_NONNULL_END
