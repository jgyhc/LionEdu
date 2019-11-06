//
//  BLAnswerSheetNavViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/24.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface BLAnswerSheetNavViewController : UINavigationController

@property (nonatomic, strong) NSArray * list;

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger functionTypeId;

@property (nonatomic, assign) NSInteger setId;

@end

NS_ASSUME_NONNULL_END
