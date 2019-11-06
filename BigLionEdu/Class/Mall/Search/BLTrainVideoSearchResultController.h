//
//  BLMallSearchResultController.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainVideoSearchResultController : UIViewController

@property (nonatomic, copy) NSString *searchStr;

@property (nonatomic, strong) UIViewController *superViewController;

@property (nonatomic, assign) NSInteger functionTypeId;

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
