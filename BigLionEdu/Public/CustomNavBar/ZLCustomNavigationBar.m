//
//  ZLCustomNavigationBar.m
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "ZLCustomNavigationBar.h"
#import <Masonry.h>
#import "AdaptScreenHelp.h"

static CGFloat sideSpace = 15.0;

@interface ZLCustomNavigationBar ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *rightContentView;


@property (nonatomic, assign) CGFloat backgroundColorAlpha;

@property (nonatomic, strong) ZLCustomNavigationBarConfiger *configer;
@end

@implementation ZLCustomNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initConfiger {
    _conversionValue = NavigationHeight() + 60;
    self.configer.opaqueTextColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.configer.transparentTextColor = [UIColor whiteColor];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setLeftImage:[UIImage imageNamed:@"nav_white_back_icon"] status:ZLCustomNavigationBarStatusTransparent];
    [self setLeftImage:[UIImage imageNamed:@"nav_black_back_icon"] status:ZLCustomNavigationBarStatusOpaque];
    [self setStatus:ZLCustomNavigationBarStatusTransparent];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)setTitle:(NSString *)title status:(ZLCustomNavigationBarStatus)status {
    switch (status) {
        case ZLCustomNavigationBarStatusTransparent: {
            self.configer.transparentTitle = title;
        }
            break;
        case ZLCustomNavigationBarStatusOpaque: {
            self.configer.opaqueTitle = title;
        }
            break;
            
        default:
            break;
    }
    self.titleLabel.text = self.configer.title;
}

- (void)setLeftImage:(UIImage *)leftImage status:(ZLCustomNavigationBarStatus)status {
    switch (status) {
        case ZLCustomNavigationBarStatusTransparent: {
            self.configer.transparentLeftImage = leftImage;
        }
            break;
        case ZLCustomNavigationBarStatusOpaque: {
            self.configer.opaqueLeftImage = leftImage;
        }
            break;
            
        default:
            break;
    }
    [self.leftButton setImage:self.configer.leftImage forState:UIControlStateNormal];
}


- (void)setTextColor:(UIColor *)textColor status:(ZLCustomNavigationBarStatus)status {
    switch (status) {
        case ZLCustomNavigationBarStatusTransparent: {
            self.configer.transparentTextColor = textColor;
        }
            break;
        case ZLCustomNavigationBarStatusOpaque: {
            self.configer.opaqueTextColor = textColor;
        }
            break;
            
        default:
            break;
    }
    self.titleLabel.textColor = self.configer.textColor;
}


- (void)setStatus:(ZLCustomNavigationBarStatus)status {
    _status = status;
    self.configer.status = status;
    self.titleLabel.textColor = self.configer.textColor;
    [self.leftButton setTitleColor:self.configer.textColor forState:UIControlStateNormal];
    for (UIView *view in self.rightContentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *) view;
            [button setTitleColor:self.configer.textColor forState:UIControlStateNormal];
        }
    }
    if (status == ZLCustomNavigationBarStatusTransparent) {
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    self.titleLabel.text = self.configer.title;
    
    [self.leftButton setImage:self.configer.leftImage forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(customNavigationBarStatusDidChangeWithStatus:)]) {
        [self.delegate customNavigationBarStatusDidChangeWithStatus:status];
    }
}

- (void)setOffsetY:(CGFloat)offsetY {
    _offsetY = offsetY;
    if (offsetY > _conversionValue) {
        CGFloat alpha = (offsetY - 120) / NavigationHeight();
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:alpha];
        self.status = ZLCustomNavigationBarStatusOpaque;
    }else {
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
        self.status = ZLCustomNavigationBarStatusTransparent;
    }
}


- (void)initSubViews {
    [self initConfiger];
    
    [self addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(52);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.leftButton.mas_centerY);
    }];
}

- (void)addButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addRightViews:@[button]];
}

- (void)addButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addRightViews:@[button]];
}

- (void)addRightViews:(NSArray<UIView *> *)views {
    if (views.count == 0) {
        return;
    }
    [self.rightContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UIView *lastView = [views lastObject];
    UIView *priorView;
    for (UIView *view in views) {
        [self.rightContentView addSubview:view];
        if (!priorView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.mas_equalTo(self.rightContentView);
                make.width.mas_equalTo(self.rightContentView.mas_height);
                if ([lastView isEqual:view]) {
                    make.left.mas_equalTo(self.rightContentView.mas_left);
                }
            }];
        }else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(priorView.mas_left).mas_offset(-5);
                make.top.bottom.mas_equalTo(self.rightContentView);
                make.width.mas_equalTo(self.rightContentView.mas_height);
                if ([lastView isEqual:view]) {
                    make.left.mas_equalTo(self.rightContentView.mas_left);
                }
            }];
        }
        priorView = view;
    }
}

- (void)handleLeftClickEvent:(id)sender {
    if (self.leftClickEventBlock) {
        self.leftClickEventBlock(sender);
    }
}

- (ZLCustomNavigationBarConfiger *)configer {
    if (!_configer) {
        _configer = [ZLCustomNavigationBarConfiger new];
    }
    return _configer;
}


- (UIView *)rightContentView {
    if (!_rightContentView) {
        _rightContentView = [[UIView alloc] init];
        [self addSubview:_rightContentView];
        [_rightContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(-sideSpace);
            make.height.mas_equalTo(44);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }
    return _rightContentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:19];
            label;
        });
    }
    return _titleLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"nav_black_back_icon"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(handleLeftClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

@end

@implementation ZLCustomNavigationBarConfiger


- (NSString *)title {
    switch (_status) {
        case ZLCustomNavigationBarStatusTransparent:
            return _transparentTitle?_transparentTitle:_opaqueTitle;
            break;
        case ZLCustomNavigationBarStatusOpaque:
            return _opaqueTitle;
            break;
            
        default:
            break;
    }
    return @"";
}

- (UIImage *)leftImage {
    switch (_status) {
        case ZLCustomNavigationBarStatusTransparent:
            return _transparentLeftImage?_transparentLeftImage:_opaqueLeftImage;
            break;
        case ZLCustomNavigationBarStatusOpaque:
            return _opaqueLeftImage;
            break;
            
        default:
            break;
    }
    return [UIImage imageNamed:@"nav_black_back_icon"];
}

- (UIColor *)textColor {
    switch (_status) {
        case ZLCustomNavigationBarStatusTransparent:
            return _transparentTextColor?_transparentTextColor:_opaqueTextColor;
            break;
        case ZLCustomNavigationBarStatusOpaque:
            return _opaqueTextColor;
            break;
            
        default:
            break;
    }
    return [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
}

@end
