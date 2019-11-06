//
//  BLTrainShareBuyAlertView.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainShareBuyAlertView : UIView

@property (nonatomic, strong) UIView *mask;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, copy) dispatch_block_t sureHandler;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
