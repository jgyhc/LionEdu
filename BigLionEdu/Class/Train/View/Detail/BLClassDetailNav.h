//
//  BLClassDetailNav.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/23.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLClassDetailNavDelegate <NSObject>

- (void)backHandler;
- (void)viewDetailHandler;
- (void)catalogueHandler;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLClassDetailNav : UIView

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, weak) id <BLClassDetailNavDelegate> delegate;

- (void)moveSlider:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
