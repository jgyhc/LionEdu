//
//  BLGoodsDetailHeaderView.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGoodsDetailHeaderView.h"
#import <Masonry.h>
#import "NTCatergory.h"

@interface BLGoodsDetailHeaderView ()


@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIButton *catalogueButton;
@property (nonatomic, strong) UIButton *recommendButton;
@property (nonatomic, strong) UIView *sliderView;

@end

@implementation BLGoodsDetailHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.detailButton];
        [self.contentView addSubview:self.catalogueButton];
        [self.contentView addSubview:self.recommendButton];
        [self.contentView addSubview:self.sliderView];
        [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(1.0/3.0);
        }];
        [self.catalogueButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.contentView);
            make.centerX.mas_equalTo(self.contentView);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(1.0/3.0);
        }];
        [self.recommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(1.0/3.0);
        }];
        
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(2);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.centerX.mas_equalTo(self.detailButton.mas_centerX);
        }];
    }
    return self;
}

- (void)setModel:(NSNumber *)model {
    _model = model;
    NSLog(@"aaaaaaaaaaaaaaaa%@", model);
//    [self bl_selectToIndex:model.integerValue];
}

- (void)bl_selectToIndex:(NSInteger)index {
    NSLog(@"移动到%ld", index);
    if (index == 1) {
        [self.sliderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(2);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.centerX.mas_equalTo(self.detailButton.mas_centerX);
        }];
    } else if (index == 2) {
        [self.sliderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(2);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.centerX.mas_equalTo(self.catalogueButton.mas_centerX);
        }];
    } else {
        [self.sliderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(2);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.centerX.mas_equalTo(self.recommendButton.mas_centerX);
        }];
    }
}

- (void)viewDetail {
    [self.delegate BLGoodsDetailHeaderViewViewDetail];
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderView.nt_centerX = self.detailButton.nt_centerX;
    }];
}

- (void)catalogue {
    [self.delegate BLGoodsDetailHeaderViewViewCatalogue];
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderView.nt_centerX = self.catalogueButton.nt_centerX;
    }];
}

- (void)recommend {
    [self.delegate BLGoodsDetailHeaderViewViewRecommend];
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
