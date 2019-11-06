//
//  BLGoodsDetailHeader.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/11.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGoodsDetailHeader.h"
#import <Masonry.h>
#import "NTCatergory.h"

@interface BLGoodsDetailHeader ()

@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIButton *catalogueButton;
@property (nonatomic, strong) UIView *sliderView;

@end

@implementation BLGoodsDetailHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.detailButton];
        [self addSubview:self.catalogueButton];
        [self addSubview:self.recommendButton];
        [self addSubview:self.sliderView];
        [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_width).multipliedBy(1.0/3.0);
        }];
        [self.catalogueButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_width).multipliedBy(1.0/3.0);
        }];
        [self.recommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_width).multipliedBy(1.0/3.0);
        }];
        
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(2);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.centerX.mas_equalTo(self.detailButton.mas_centerX);
        }];
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor nt_colorWithHexString:@"#E5E5E5"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.mas_equalTo(0.5);
            make.bottom.offset(0);
        }];
    }
    return self;
}

- (void)bl_selectToIndex:(NSInteger)index {
    if (index == 1) {
        [UIView animateWithDuration:0.2 animations:^{
            self.sliderView.nt_centerX = self.detailButton.nt_centerX;
        }];
    } else if (index == 2) {
        [UIView animateWithDuration:0.2 animations:^{
            self.sliderView.nt_centerX = self.catalogueButton.nt_centerX;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.sliderView.nt_centerX = self.recommendButton.nt_centerX;
        }];
    }
}


- (void)setModel:(NSNumber *)model {
    _model = model;
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.centerX.mas_equalTo(self.detailButton.mas_centerX);
    }];
}


- (void)viewDetail {
    [self.delegate BLGoodsDetailHeaderViewDetail];
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderView.nt_centerX = self.detailButton.nt_centerX;
    }];
}

- (void)catalogue {
    [self.delegate BLGoodsDetailHeaderCatalogue];
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderView.nt_centerX = self.catalogueButton.nt_centerX;
    }];
}

- (void)recommend {
    [self.delegate BLGoodsDetailHeaderRecommend];
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderView.nt_centerX = self.recommendButton.nt_centerX;
    }];
}

- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:[UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:73/255.0 green:73/255.0 blue:94/255.0 alpha:1.0] forState:UIControlStateSelected];
            [button setTitle:@"详情介绍" forState:UIControlStateNormal];
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
            [button setTitle:@"目录" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(catalogue) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    };
     return   _catalogueButton;
}

- (UIButton *)recommendButton {
    if (!_recommendButton) {
        _recommendButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:[UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:73/255.0 green:73/255.0 blue:94/255.0 alpha:1.0] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitle:@"推荐" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(recommend) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _recommendButton;
}



- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [UIView new];
        _sliderView.backgroundColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    }
    return _sliderView;
}

@end
