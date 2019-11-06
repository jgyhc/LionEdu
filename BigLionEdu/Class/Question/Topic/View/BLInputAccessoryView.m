//
//  BLInputAccessoryView.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLInputAccessoryView.h"
#import <Masonry.h>

@interface BLInputAccessoryView ()

@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic, strong) UIButton *photoButton;

@property (nonatomic, strong) UIButton * finishButton;

@end

@implementation BLInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    [self setBackgroundColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0]];
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
    }];
    
    
    [self.stackView addArrangedSubview:self.photoButton];
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stackView.mas_top);
        make.bottom.mas_equalTo(self.stackView.mas_bottom);
        make.width.mas_equalTo(50);
    }];
    
    [self.stackView addArrangedSubview:self.cameraButton];
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stackView.mas_top);
        make.bottom.mas_equalTo(self.stackView.mas_bottom);
        make.width.mas_equalTo(50);
    }];

    [self addSubview:self.finishButton];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self);
        make.width.mas_equalTo(60);
    }];
}

- (void)photoSelectEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoSelectEvent)]) {
        [self.delegate photoSelectEvent];
    }
}

- (void)cameraSelectEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraSelectEvent)]) {
        [self.delegate cameraSelectEvent];
    }
}

- (void)finishEvent:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishEvent)]) {
        [self.delegate finishEvent];
    }
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
        _stackView.alignment = UIStackViewAlignmentCenter;
    }
    return _stackView;
}

- (UIButton *)photoButton {
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setImage:[UIImage imageNamed:@"t_zp"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(photoSelectEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoButton;
}

- (UIButton *)cameraButton {
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"t_xj"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(cameraSelectEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_finishButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton addTarget:self action:@selector(finishEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}

@end
