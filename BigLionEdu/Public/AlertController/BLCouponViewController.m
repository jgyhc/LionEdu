//
//  BLCouponViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLCouponViewController.h"
#import <Masonry.h>
#import "BLAPPMyselfGetreceiveCouponListAPI.h"
#import "ZLUserInstance.h"
#import "LCProgressHUD.h"

@interface BLCouponViewController ()<MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (nonatomic, strong) UIImageView * backgroundImageView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UITextField * textField;

@property (nonatomic, strong) UIControl * scanButton;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) UIButton * closeButton;

@property (nonatomic, strong) BLAPPMyselfExchangeCouponAPI *appMyselfExchangeCouponAPI;
@end

@implementation BLCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView.mas_centerX);
        make.top.mas_equalTo(self.containerView.mas_top).mas_offset(86);
    }];
    
    [self.containerView addSubview:self.scanButton];
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.containerView.mas_right).mas_offset(-10);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(34);
    }];
    
    [self.containerView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containerView.mas_left).mas_offset(10);
        make.centerY.mas_equalTo(self.scanButton.mas_centerY);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(self.scanButton.mas_left).mas_offset(-20);
    }];
    
    [self.containerView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView.mas_centerX);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).mas_offset(-14);
        make.width.mas_equalTo(158);
        make.height.mas_equalTo(36);
    }];
    
    [self.view addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView.mas_centerX);
        make.top.mas_equalTo(self.containerView.mas_bottom).mas_offset(27);
    }];
}

- (void)handlerScanEvent:(id)sender {
    self.actionBlock(scan);
    [self hide];
}

- (BOOL)isModal {
    return YES;
}

- (CGFloat)horizontalEdge {
    return 60;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:@"my_wdyhq_dh_bj"];
    }
    return _backgroundImageView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.layer.cornerRadius = 4;
        _textField.layer.borderColor = [UIColor whiteColor].CGColor;
        _textField.layer.borderWidth = 1;
        _textField.placeholder = @"输入兑换码";
        //文字偏移量
        _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 10, 0)];
        //设置显示模式为永远显示(默认不显示)
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}


- (UIControl *)scanButton {
    if (!_scanButton) {
        _scanButton = ({
            UIControl *control = [[UIControl alloc] init];
            control;
        });
        UIImageView *imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_wdyhq_scan"]];
            imageView;
        });
        [_scanButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_scanButton.mas_centerX);
            make.top.mas_equalTo(_scanButton.mas_top);
        }];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:12];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.text = @"扫码输入";
        [_scanButton addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_scanButton.mas_centerX);
            make.bottom.mas_equalTo(_scanButton.mas_bottom);
        }];
        
        [_scanButton addTarget:self action:@selector(handlerScanEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setBackgroundColor:[UIColor colorWithRed:251/255.0 green:236/255.0 blue:81/255.0 alpha:1.0]];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton setTitleColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(exchaneAction:) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.layer.cornerRadius = 18;
        [_sureButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        _sureButton.clipsToBounds = YES;
    }
    return _sureButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"my_wdyhq_gb"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

-(void)exchaneAction:(UIButton *)sender {
    if (self.textField.text.length <= 4) {
        [self.appMyselfExchangeCouponAPI loadData];
    }
}

#pragma mark data

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.appMyselfExchangeCouponAPI isEqual:manager]) {
        return @{@"token": ZLUserInstance.sharedInstance.token,
                 @"couponCode":self.textField.text
                 };
    }
    return nil;
}

- (BLAPPMyselfExchangeCouponAPI *)appMyselfExchangeCouponAPI{
    if (!_appMyselfExchangeCouponAPI) {
        _appMyselfExchangeCouponAPI =[[BLAPPMyselfExchangeCouponAPI alloc]init];
        _appMyselfExchangeCouponAPI.mj_delegate =self;
        _appMyselfExchangeCouponAPI.paramSource =self;
    }
    return _appMyselfExchangeCouponAPI;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    if (code != 200) {
        return;
    }
    self.actionBlock(exChangeSuccess);
}

- (void)failManager:(CTAPIBaseManager *)manager {
//    [LCProgressHUD show:manager.]
}

@end
