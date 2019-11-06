//
//  BLMallScreeningViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/31.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectScreenHanlder)(NSString *discountTypePick, NSString *type);

@protocol BLMallScreeningViewControllerDelegate <NSObject>

- (void)BLMallScreeningViewController:(NSString *)Id type:(NSString *)type;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLMallScreeningViewController : UIViewController

@property (nonatomic, copy) DidSelectScreenHanlder didSelectScreenHanlder;
@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, weak) id <BLMallScreeningViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString *currentType;
@property (nonatomic, copy) NSString *currentDisType;

@end

NS_ASSUME_NONNULL_END
