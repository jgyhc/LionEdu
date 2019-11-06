//
//  BLMallOrderSureNumberView.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BLMallOrderSureNumberViewHandler)(NSInteger num);
NS_ASSUME_NONNULL_BEGIN

@interface BLMallOrderSureNumberView : UIView

@property (nonatomic, strong) UIButton * reduceButton;

@property (nonatomic, strong) UIButton * addButton;

@property (nonatomic, strong) UITextField * quantityLabel;
@property (nonatomic, copy) BLMallOrderSureNumberViewHandler orderSureNumberViewHandler;

@end

NS_ASSUME_NONNULL_END
