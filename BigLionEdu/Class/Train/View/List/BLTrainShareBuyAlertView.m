//
//  BLTrainShareBuyAlertView.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainShareBuyAlertView.h"
#import <Masonry.h>
#import "NTCatergory.h"

@interface BLTrainShareBuyAlertView ()


@end

@implementation BLTrainShareBuyAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self rt_initailizeUI];
    }
    return self;
}

- (void)rt_initailizeUI {
    self.frame = CGRectMake(0, 0, NT_SCREEN_WIDTH, NT_SCREEN_HEIGHT);
    self.mask = [[UIView alloc] initWithFrame:self.bounds];
    self.mask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:self.mask];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.cornerRadius = 5.0;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(225, 197));
        make.center.mas_equalTo(self);
    }];
    
    self.titleLab = [UILabel new];
    self.titleLab.textColor = [UIColor nt_colorWithHexString:@"#333333"];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.font = [UIFont boldSystemFontOfSize:17];
    self.titleLab.text = @"大狮解狮吼一声";
    self.titleLab.backgroundColor = [UIColor nt_colorWithHexString:@"#F6F7FA"];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(53);
    }];
    
    self.priceLab = [UILabel new];
    self.priceLab.textColor = [UIColor nt_colorWithHexString:@"#E63535"];
    self.priceLab.textAlignment = NSTextAlignmentCenter;
    self.priceLab.font = [UIFont systemFontOfSize:12];
    self.priceLab.text = @"￥20.0";
    [self.contentView addSubview:self.priceLab];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.titleLab.mas_bottom).offset(17);
    }];
    
    self.detailLab = [UILabel new];
    self.detailLab.textColor = [UIColor nt_colorWithHexString:@"#666666"];
    self.detailLab.textAlignment = NSTextAlignmentCenter;
    self.detailLab.font = [UIFont systemFontOfSize:14];
    self.detailLab.text = @"购买可解锁所有“狮享刻”";
    self.detailLab.numberOfLines = 0;
    [self.contentView addSubview:self.detailLab];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.priceLab.mas_bottom).offset(19);
        make.width.mas_equalTo(140);
    }];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelBtn setTitleColor:[UIColor nt_colorWithHexString:@"#FF6B00"] forState:UIControlStateNormal];
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = [UIColor nt_colorWithHexString:@"#FF6B00"].CGColor;
    self.cancelBtn.cornerRadius = 11;
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(69, 22));
        make.left.offset(15);
        make.bottom.offset(-19);
    }];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureBtn setBackgroundColor:[UIColor nt_colorWithHexString:@"#FF6B00"]];
    self.sureBtn.cornerRadius = 11;
    [self.sureBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(69, 22));
        make.right.offset(-15);
        make.bottom.offset(-19);
    }];
    [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.mask.alpha = 1;
        self.contentView.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.mask.alpha = 0;
        self.contentView.alpha = 0;
    }];
    [self removeFromSuperview];
}

- (void)cancel {
    
    [self dismiss];
}

- (void)sure {
    self.sureHandler();
    [self dismiss];
}

@end
