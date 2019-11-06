//
//  BLGoodsDetailHeaderViewCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/9.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGoodsDetailHeaderViewCell.h"
#import <Masonry.h>
#import "NTCatergory.h"

@interface BLGoodsDetailHeaderViewCell ()

@property (nonatomic, strong) UIView *sliderView1;
@property (nonatomic, strong) UIView *sliderView2;
@property (nonatomic, strong) UIView *sliderView3;

@end

@implementation BLGoodsDetailHeaderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self rt_initailizeUI];
    }
    return self;
}

- (void)rt_initailizeUI {
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.detailButton];
    [self.contentView addSubview:self.catalogueButton];
    [self.contentView addSubview:self.recommendButton];
    [self.contentView addSubview:self.sliderView1];
    [self.contentView addSubview:self.sliderView2];
    [self.contentView addSubview:self.sliderView3];
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
    
    [self.sliderView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.centerX.mas_equalTo(self.detailButton.mas_centerX);
    }];
    
    [self.sliderView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.centerX.mas_equalTo(self.catalogueButton.mas_centerX);
    }];
    
    [self.sliderView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.centerX.mas_equalTo(self.recommendButton.mas_centerX);
    }];
    self.sliderView2.hidden = self.sliderView3.hidden = YES;
}

- (void)setModel:(NSMutableDictionary *)model {
    _model = model;
    [self.recommendButton setTitle:model[@"tj"] forState:UIControlStateNormal];
    [self bl_selectToIndex:[model[@"index"] integerValue]];
}

- (void)bl_selectToIndex:(NSInteger)index {
    NSLog(@"移动到%ld", index);
    if (index == 1) {
        self.sliderView1.hidden = NO;
        self.sliderView2.hidden = self.sliderView3.hidden = YES;
    } else if (index == 2) {
        self.sliderView2.hidden = NO;
        self.sliderView1.hidden = self.sliderView3.hidden = YES;
    } else {
        self.sliderView3.hidden = NO;
        self.sliderView2.hidden = self.sliderView1.hidden = YES;
    }
}

- (void)viewDetail {
    [self.delegate BLGoodsDetailHeaderViewCellDetail];
    self.sliderView1.hidden = NO;
    self.sliderView2.hidden = self.sliderView3.hidden = YES;
}

- (void)catalogue {
    [self.delegate BLGoodsDetailHeaderViewCellCatalogue];
    self.sliderView2.hidden = NO;
    self.sliderView1.hidden = self.sliderView3.hidden = YES;
}

- (void)recommend {
    [self.delegate BLGoodsDetailHeaderViewCellRecommend];
    self.sliderView3.hidden = NO;
    self.sliderView2.hidden = self.sliderView1.hidden = YES;
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


- (UIView *)sliderView1 {
    if (!_sliderView1) {
        _sliderView1 = [UIView new];
        _sliderView1.backgroundColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    }
    return _sliderView1;
}

- (UIView *)sliderView2 {
    if (!_sliderView2) {
        _sliderView2 = [UIView new];
        _sliderView2.backgroundColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    }
    return _sliderView2;
}

- (UIView *)sliderView3 {
    if (!_sliderView3) {
        _sliderView3 = [UIView new];
        _sliderView3.backgroundColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    }
    return _sliderView3;
}


@end
