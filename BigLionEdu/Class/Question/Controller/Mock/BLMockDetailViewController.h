//
//  BLMockDetailViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMockItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLMockDetailViewController : UIViewController

@property (nonatomic, strong) BLMockItemModel *model;

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger functionTypeId;

@end

NS_ASSUME_NONNULL_END
