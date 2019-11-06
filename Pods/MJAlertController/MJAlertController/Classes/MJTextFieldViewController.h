//
//  MJTextFieldViewController.h
//  LCAlertController
//
//  Created by manjiwang on 2019/6/6.
//

#import "MJAlertController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MJTextFieldViewController : MJAlertController

@property (nonatomic, strong) UITextField * textField;

- (instancetype)initWithTitle:(nullable NSString *)title placeholder:(nullable NSString *)placeholder buttons:(nullable NSArray *)buttons tapBlock:(nullable MJAlertControllerCompletionBlock)tapBlock;
@end

NS_ASSUME_NONNULL_END
