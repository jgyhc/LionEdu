//
//  MJWebNavigationView.m
//  MJWebViewKit_Example
//
//  Created by -- on 2019/2/18.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import "MJWebNavigationView.h"
#import <Masonry/Masonry.h>
#import "UIButton+WebCache.h"

#define MJWebe_UICOLOR_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MJWebNavigationView ()

@property (nonatomic, strong) UIButton * backButton;

@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation MJWebNavigationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.tintColor = MJWebe_UICOLOR_HEX(0x37A1FF);
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.backButton];
    [self addSubview:self.closeButton];
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self);
        make.width.mas_lessThanOrEqualTo(300);
        make.height.mas_equalTo(44);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(60);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backButton.mas_right).mas_offset(5);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:MJWebe_UICOLOR_HEX(0xdbdbdb)];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.6);
    }];
}

- (void)setType:(MJWebNavigationViewType)type {
    _type = type;
    switch (type) {
        case MJWebNavigationViewTypeNormal: {
            [self initSubViews];
        }
            break;
        case MJWebNavigationViewTypeOnlyStatusBar: {
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
            break;
        case MJWebNavigationViewTypeNoNavigationView: {
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
            break;
            
        default:
            break;
    }
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)addBackAndCloseButtonWithTarget:(nullable id)target backAction:(SEL)backAction closeAction:(SEL)closeAction {
    [self.closeButton addTarget:target action:closeAction forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:target action:backAction forControlEvents:UIControlEventTouchUpInside];
}

- (void)addRightButtonWithTitle:(NSString *)title target:(nullable id)target action:(SEL)action {
    [self.rightButton setImage:nil forState:UIControlStateNormal];
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self addButtontarget:target action:action isText:YES];
}

- (void)addRightButtonWithImageUrl:(NSString *)imageUrl target:(nullable id)target action:(SEL)action {
    [self.rightButton setTitle:nil forState:UIControlStateNormal];
    [self.rightButton sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
    [self addButtontarget:target action:action isText:NO];
}

- (void)addRightButtonWithImageName:(NSString *)imageName target:(nullable id)target action:(SEL)action {
    [self.rightButton setTitle:nil forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self addButtontarget:target action:action isText:NO];
}

- (void)addButtontarget:(nullable id)target action:(SEL)action isText:(BOOL)isText {
    [self addSubview:self.rightButton];
    if (isText) {
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(-10);
            make.height.mas_equalTo(44);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }else {
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(-10);
            make.height.width.mas_equalTo(44);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }
    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}



- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"nav_black_back_icon"] forState:UIControlStateNormal];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 18, 10, 18);
    }
    return _backButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:MJWebe_UICOLOR_HEX(0x333333) forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _closeButton.hidden = YES;
    }
    return _closeButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _rightButton.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        _rightButton.imageView.tintColor = MJWebe_UICOLOR_HEX(0x37A1FF);
        //        _rightButton.imageView.contentMode = UIViewContentModeCenter;
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_rightButton setTitleColor:MJWebe_UICOLOR_HEX(0x333333) forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _rightButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = MJWebe_UICOLOR_HEX(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
