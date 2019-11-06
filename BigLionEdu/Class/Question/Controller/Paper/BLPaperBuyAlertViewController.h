//
//  BLPaperBuyAlertViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/2.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "LCAlertController.h"

NS_ASSUME_NONNULL_BEGIN
extern  NSString * const BLPaperBuyAlertControllerButtonTitleKey;
extern  NSString * const BLPaperBuyAlertControllerButtonTextColorKey;
extern  NSString * const BLPaperBuyAlertControllerButtonFontKey;
extern  NSString * const BLPaperBuyAlertControllerButtonNormalBackgroundColorKey;
extern  NSString * const BLPaperBuyAlertControllerButtonHighlightedBackgroundColorKey;
extern  NSString * const BLPaperBuyAlertControllerButtonRoundedCornersKey;//圆角值
extern  NSString * const BLPaperBuyAlertControllerButtonBorderWidthKey;//边框宽
extern  NSString * const BLPaperBuyAlertControllerButtonBorderColorKey;//边框颜色
@class BLPaperBuyAlertViewController;
typedef void (^BLPaperBuyAlertControllerCompletionBlock) (BLPaperBuyAlertViewController * __nonnull controller, NSString * __nonnull title, NSInteger buttonIndex);
@interface BLPaperBuyAlertViewController : LCAlertController

- (instancetype)initWithTitle:(nullable NSString *)title content:(NSString *)content buttons:(nullable NSArray *)buttons tapBlock:(nullable BLPaperBuyAlertControllerCompletionBlock)tapBlock;

@property (nonatomic, copy) BLPaperBuyAlertControllerCompletionBlock tapBlock;

@property (nonatomic, copy) NSString *priceString;
@property (nonatomic, assign) NSTextAlignment textAlignment;

@end

NS_ASSUME_NONNULL_END
