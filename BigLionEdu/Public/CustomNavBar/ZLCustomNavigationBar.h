//
//  ZLCustomNavigationBar.h
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    ZLCustomNavigationBarStatusTransparent,//透明状态
    ZLCustomNavigationBarStatusOpaque,//不透明状态
} ZLCustomNavigationBarStatus;

@protocol ZLCustomNavigationBarDelegate <NSObject>

- (void)customNavigationBarStatusDidChangeWithStatus:(ZLCustomNavigationBarStatus)status;

@end


@class ZLCustomNavigationBarConfiger;
@interface ZLCustomNavigationBar : UIView

@property (nonatomic, weak) id<ZLCustomNavigationBarDelegate> delegate;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, assign) ZLCustomNavigationBarStatus status;

@property (nonatomic, assign) CGFloat conversionValue;

@property (nonatomic, assign) CGFloat offsetY;

@property (nonatomic, copy) void (^leftClickEventBlock)(id sender);

- (void)setTitle:(NSString *)title status:(ZLCustomNavigationBarStatus)status;

- (void)setLeftImage:(UIImage *)leftImage status:(ZLCustomNavigationBarStatus)status;

- (void)setTextColor:(UIColor *)textColor status:(ZLCustomNavigationBarStatus)status;

- (void)addButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action;
- (void)addButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)addRightViews:(NSArray<UIView *> *)views;

@end

@interface ZLCustomNavigationBarConfiger : NSObject

@property (nonatomic, assign) ZLCustomNavigationBarStatus status;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIImage *leftImage;



@property (nonatomic, copy) NSString *transparentTitle;

@property (nonatomic, strong) UIColor *transparentTextColor;

@property (nonatomic, strong) UIImage *transparentLeftImage;



@property (nonatomic, copy) NSString *opaqueTitle;

@property (nonatomic, strong) UIColor *opaqueTextColor;

@property (nonatomic, strong) UIImage *opaqueLeftImage;



@end

NS_ASSUME_NONNULL_END
