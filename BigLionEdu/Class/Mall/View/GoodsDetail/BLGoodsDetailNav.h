//
//  BLGoodsDetailNav.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/11.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLGoodsDetailNav : UIView

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *b_backBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *cartBtn;
@property (nonatomic, strong) UILabel *numLab;

@property (nonatomic, copy) dispatch_block_t backHandler;
@property (nonatomic, copy) dispatch_block_t shareHandler;
@property (nonatomic, copy) dispatch_block_t cartHandler;

- (void)bl_topStyle;
- (void)bl_normalStyle;

@end

NS_ASSUME_NONNULL_END
