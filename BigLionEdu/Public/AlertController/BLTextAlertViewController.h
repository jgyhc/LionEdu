//
//  BLTextAlertViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/25.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "LCAlertController.h"


NS_ASSUME_NONNULL_BEGIN
extern  NSString * const BLAlertControllerButtonTitleKey;
extern  NSString * const BLAlertControllerButtonTextColorKey;
extern  NSString * const BLAlertControllerButtonFontKey;
extern  NSString * const BLAlertControllerButtonNormalBackgroundColorKey;
extern  NSString * const BLAlertControllerButtonHighlightedBackgroundColorKey;
extern  NSString * const BLAlertControllerButtonRoundedCornersKey;//圆角值
extern  NSString * const BLAlertControllerButtonBorderWidthKey;//边框宽
extern  NSString * const BLAlertControllerButtonBorderColorKey;//边框颜色
@class BLTextAlertViewController;
typedef void (^BLAlertControllerCompletionBlock) (BLTextAlertViewController * __nonnull controller, NSString * __nonnull title, NSInteger buttonIndex);

@interface BLTextAlertViewController : LCAlertController

- (instancetype)initWithTitle:(nullable NSString *)title content:(NSString *)content buttons:(nullable NSArray *)buttons tapBlock:(nullable BLAlertControllerCompletionBlock)tapBlock;

@property (nonatomic, copy) BLAlertControllerCompletionBlock tapBlock;

@end

NS_ASSUME_NONNULL_END
