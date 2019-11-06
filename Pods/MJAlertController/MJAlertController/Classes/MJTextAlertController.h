//
//  MJTextAlertController.h
//  MJAlertController_Example
//
//  Created by manjiwang on 2019/5/14.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import "MJAlertController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MJTextAlertController : MJAlertController

- (instancetype)initWithTitle:(nullable NSString *)title content:(nullable NSString *)content buttons:(nullable NSArray *)buttons tapBlock:(nullable MJAlertControllerCompletionBlock)tapBlock;

@end

NS_ASSUME_NONNULL_END
