//
//  BLOffLineVideoHeaderView.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLOffLineVideoHeaderView.h"
#import <Masonry.h>
#import "NTCatergory.h"

@interface BLOffLineVideoHeaderView ()

@property (nonatomic, strong) UIButton *lbBtn;
@property (nonatomic, strong) UIButton *msBtn;
@property (nonatomic, strong) UIView *line;

@end

@implementation BLOffLineVideoHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self rt_initailizeUI];
    }
    return self;
}

- (void)rt_initailizeUI {
    self.lbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lbBtn setTitle:@"录播" forState:UIControlStateNormal];
    [self.lbBtn setTitleColor:[UIColor nt_colorWithHexString:@"#878C97"] forState:UIControlStateNormal];
    [self.lbBtn setTitleColor:[UIColor nt_colorWithHexString:@"#FF6B00"] forState:UIControlStateSelected];
    self.lbBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.lbBtn];
    [self.lbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.contentView);
        make.width.mas_equalTo(NT_SCREEN_WIDTH / 2.0);
    }];
    
    self.msBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.msBtn setTitle:@"面试" forState:UIControlStateNormal];
    [self.msBtn setTitleColor:[UIColor nt_colorWithHexString:@"#878C97"] forState:UIControlStateNormal];
    [self.msBtn setTitleColor:[UIColor nt_colorWithHexString:@"#FF6B00"] forState:UIControlStateSelected];
    self.msBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.msBtn];
    [self.msBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self.contentView);
        make.width.mas_equalTo(NT_SCREEN_WIDTH / 2.0);
    }];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor nt_colorWithHexString:@"#E5E5E5"];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.8);
    }];
    
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor nt_colorWithHexString:@"#FF6B00"];
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(NT_SCREEN_WIDTH / 2.0, 2.0));
    }];
    [self.lbBtn addTarget:self action:@selector(bl_lbVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.msBtn addTarget:self action:@selector(bl_msVideo) forControlEvents:UIControlEventTouchUpInside];
}


- (void)bl_lbVideo {
    self.lbBtn.selected = YES;
    self.msBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.line.nt_centerX = self.lbBtn.nt_centerX;
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(BLOffLineVideoHeaderViewDidChangeIndex:)]) {
        [self.delegate BLOffLineVideoHeaderViewDidChangeIndex:1];
    }
}

- (void)bl_msVideo {
    self.lbBtn.selected = NO;
    self.msBtn.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.line.nt_centerX = self.msBtn.nt_centerX;
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(BLOffLineVideoHeaderViewDidChangeIndex:)]) {
        [self.delegate BLOffLineVideoHeaderViewDidChangeIndex:2];
    }
}

@end
