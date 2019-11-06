//
//  BLClassDetailNav.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/23.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLClassDetailNav.h"
#import <Masonry.h>
#import "NTCatergory.h"
#import "AdaptScreenHelp.h"

@interface BLClassDetailNav ()

@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIButton *catalogueButton;
@property (nonatomic, strong) UIView *sliderView;

@end

@implementation BLClassDetailNav

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLab = [UILabel new];
        self.titleLab.text = @"详情";
        self.titleLab.textColor = [UIColor nt_colorWithHexString:@"#333333"];
        self.titleLab.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.offset(StatusBarHeight() + 10);
        }];
        
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backBtn setImage:[UIImage imageNamed:@"nav_black_back_icon"] forState:UIControlStateNormal];
        [self addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab.mas_centerY);
            make.left.offset(15);
        }];
        [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.backBtn.externalTouchInset = UIEdgeInsetsMake(15, 15, 15, 15);
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor nt_colorWithHexString:@"#E5E5E5"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        
        [self addSubview:self.detailButton];
        [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(NTWidthRatio(80));
            make.bottom.equalTo(self);
        }];
        
        [self addSubview:self.catalogueButton];
        [self.catalogueButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(NTWidthRatio(-80));
            make.bottom.equalTo(self);
        }];
        
        [self addSubview:self.sliderView];
        self.sliderView.cornerRadius = 1.5;
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(3);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.centerX.mas_equalTo(self.detailButton.mas_centerX);
        }];
        
    }
    return self;
}

- (void)moveSlider:(NSInteger)index {
    [UIView animateWithDuration:0.2 animations:^{
        if (index == 1) {
            self.sliderView.nt_centerX = self.detailButton.nt_centerX;
        } else {
            self.sliderView.nt_centerX = self.catalogueButton.nt_centerX;
        }
    }];
}

- (void)back {
    [self.delegate backHandler];
}

- (void)viewDetail {
    [self moveSlider:1];
    [self.delegate viewDetailHandler];
}

- (void)catalogue {
    [self moveSlider:2];
    [self.delegate catalogueHandler];
}

- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:[UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:73/255.0 green:73/255.0 blue:94/255.0 alpha:1.0] forState:UIControlStateSelected];
            [button setTitle:@"课程介绍" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button addTarget:self action:@selector(viewDetail) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _detailButton;
}

- (UIButton *)catalogueButton {
    if (!_catalogueButton){
        _catalogueButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:[UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:73/255.0 green:73/255.0 blue:94/255.0 alpha:1.0] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitle:@"课程表" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(catalogue) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    };
     return   _catalogueButton;
}


- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [UIView new];
        _sliderView.backgroundColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    }
    return _sliderView;
}

@end
