//
//  BLGoodsDetailNav.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/11.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGoodsDetailNav.h"
#import "NTCatergory.h"
#import <Masonry.h>
#import <BlocksKit+UIKit.h>

@implementation BLGoodsDetailNav

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self rt_initailizeUI];
    }
    return self;
}

- (void)rt_initailizeUI {
    self.titleLab = [UILabel new];
    self.titleLab.text = @"详情";
    self.titleLab.textColor = [UIColor nt_colorWithHexString:@"#333333"];
    self.titleLab.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.offset(-8);
    }];
    self.titleLab.hidden = YES;
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"nav_black_back_icon"] forState:UIControlStateNormal];
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab.mas_centerY);
        make.left.offset(15);
    }];
    self.backBtn.externalTouchInset = UIEdgeInsetsMake(15, 15, 15, 15);
    self.backBtn.hidden = YES;

    self.b_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.b_backBtn setImage:[UIImage imageNamed:@"m_detail_back"] forState:UIControlStateNormal];
    [self.b_backBtn setBackgroundColor:[UIColor nt_colorWithHexString:@"#000000" alpha:0.4]];
    self.b_backBtn.cornerRadius = 25/2.0;
    [self addSubview:self.b_backBtn];
    [self.b_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab.mas_centerY);
        make.left.offset(15);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    self.backBtn.externalTouchInset = self.b_backBtn.externalTouchInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareBtn setImage:[UIImage imageNamed:@"m_detail_s"] forState:UIControlStateNormal];
    [self.shareBtn setBackgroundColor:[UIColor nt_colorWithHexString:@"#000000" alpha:0.4]];
    self.shareBtn.cornerRadius = 25/2.0;
    [self addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab.mas_centerY);
        make.right.offset(-15);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    self.cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cartBtn setImage:[UIImage imageNamed:@"m_detail_cart"] forState:UIControlStateNormal];
    self.cartBtn.cornerRadius = 25/2.0;
    [self.cartBtn setBackgroundColor:[UIColor nt_colorWithHexString:@"#000000" alpha:0.4]];
    
    [self addSubview:self.cartBtn];
    [self.cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab.mas_centerY);
        make.right.equalTo(self.shareBtn.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    self.numLab = [UILabel new];
    self.numLab.backgroundColor = [UIColor redColor];
    self.numLab.textColor = [UIColor whiteColor];
    self.numLab.font = [UIFont systemFontOfSize:9];
    self.numLab.textAlignment = NSTextAlignmentCenter;
    self.numLab.cornerRadius = 7.5;
    self.numLab.text = @"0";
    [self addSubview:self.numLab];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cartBtn.mas_right).offset(6);
        make.top.equalTo(self.cartBtn.mas_top).offset(-4);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    __weak typeof(self) wself = self;
    [self.backBtn bk_addEventHandler:^(id sender) {
        wself.backHandler();
    } forControlEvents:UIControlEventTouchUpInside];
    [self.b_backBtn bk_addEventHandler:^(id sender) {
        wself.backHandler();
    } forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn bk_addEventHandler:^(id sender) {
        wself.shareHandler();
    } forControlEvents:UIControlEventTouchUpInside];
    [self.cartBtn bk_addEventHandler:^(id sender) {
        wself.cartHandler();
    } forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)bl_topStyle {
    self.backgroundColor = [UIColor whiteColor];
    self.b_backBtn.hidden = self.shareBtn.hidden = self.cartBtn.hidden = self.numLab.hidden = YES;
    self.backBtn.hidden = self.titleLab.hidden = NO;
}

- (void)bl_normalStyle {
    self.backgroundColor = [UIColor clearColor];
    self.b_backBtn.hidden = self.shareBtn.hidden = self.cartBtn.hidden = self.numLab.hidden = NO;
    self.backBtn.hidden = self.titleLab.hidden = YES;
    if (self.numLab.text.integerValue == 0) {
        self.numLab.hidden = YES;
    }
}

@end
