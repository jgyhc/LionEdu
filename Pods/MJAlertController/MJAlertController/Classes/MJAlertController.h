//
//  MJAlertController.h
//  MJAlertController_Example
//
//  Created by manjiwang on 2019/5/14.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import "LCAlertController.h"

extern  NSString * const MJAlertControllerButtonTitleKey;
extern  NSString * const MJAlertControllerButtonTextColorKey;
extern  NSString * const MJAlertControllerButtonFontKey;
extern  NSString * const MJAlertControllerButtonNormalBackgroundColorKey;
extern  NSString * const MJAlertControllerButtonHighlightedBackgroundColorKey;
NS_ASSUME_NONNULL_BEGIN
@class MJAlertController;
typedef void (^MJAlertControllerCompletionBlock) (MJAlertController * __nonnull controller, NSString * __nonnull title, NSInteger buttonIndex);

@interface MJAlertController : LCAlertController

@property (nonatomic, assign, readonly) CGFloat buttonsHeight;//按钮高度

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@property (nonatomic, strong) UIView * contentView;


- (void)initContentView;

@property (nonatomic, copy) MJAlertControllerCompletionBlock tapBlock;

- (instancetype)initWithTitle:(nullable NSString *)title buttons:(nullable NSArray *)buttons tapBlock:(nullable MJAlertControllerCompletionBlock)tapBlock;

@end

NS_ASSUME_NONNULL_END
