//
//  BLPasswordViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/20.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLPasswordViewController.h"
#import <MJRefresh.h>
#import <YYModel.h>
#import "BLResetPasswordAPI.h"
#import <LCProgressHUD.h>
#import "BLCheckCodeAPI.h"
#import "BLAppLoginRegisterSendCodeAPI.h"
#import "UIButton+YasinTimerCategory.h"
#import "ZLUserInstance.h"

@interface BLPasswordViewController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (nonatomic, strong) BLResetPasswordAPI *resetPasswordAPI;
@property (nonatomic, strong) BLCheckCodeAPI * checkCodeAPI;
@property (nonatomic, strong) BLAppLoginRegisterSendCodeAPI * appLoginRegisterSendCodeAPI;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation BLPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.contentView layoutIfNeeded];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, self.sureButton.bounds.size.width, 35);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:217/255.0 blue:120/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0].CGColor];
    gl.cornerRadius = 17.5;
    gl.locations = @[@(0.0),@(1.0)];
    
    [_sureButton.layer addSublayer:gl];
    [_sureButton.layer insertSublayer:gl atIndex:0];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:94/255.0 alpha:1.0];
}

- (IBAction)getCodeEvent:(id)sender {
    if (self.phoneTextField.text.length == 0) {
        [LCProgressHUD show:@"请输入手机号码"];
        return;
    }
    if (self.phoneTextField.text.length != 11) {
        [LCProgressHUD show:@"请输入11位手机号码"];
        return;
    }
    self.appLoginRegisterSendCodeAPI.urlParams = @{@"mobile": self.phoneTextField.text?self.phoneTextField.text:@""};
    [self.appLoginRegisterSendCodeAPI loadData];
    [sender startCountDownTime:60 withCountDownBlock:^{
        
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.resetPasswordAPI isEqual:manager]) {
        return @{@"mobile":_phoneTextField.text ? _phoneTextField.text: @"",
                 @"password": _passwordTextField.text ? _passwordTextField.text: @""
                 };
    }
    if ([self.checkCodeAPI isEqual:manager]) {
        return @{@"mobile": _phoneTextField.text?_phoneTextField.text:@"",
                 @"code": _codeTextField.text?_codeTextField.text:@""
                 };
    }
    if ([self.appLoginRegisterSendCodeAPI isEqual:manager]) {
        return @{@"mobile": _phoneTextField.text?_phoneTextField.text:@""};
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.resetPasswordAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [LCProgressHUD show:@"修改成功，请重新登录"];
            [[ZLUserInstance sharedInstance] removeUserInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    if ([self.checkCodeAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [self.resetPasswordAPI loadData];
        }
    }
    if ([self.appLoginRegisterSendCodeAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
             [self.codeTextField becomeFirstResponder];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}


- (IBAction)sureEvent:(id)sender {
    if (self.phoneTextField.text.length == 0) {
        [LCProgressHUD show:@"请输入手机号码"];
        return;
    }
    if (self.phoneTextField.text.length != 11) {
        [LCProgressHUD show:@"请输入11位手机号码"];
        return;
    }
    if (self.codeTextField.text.length == 0) {
        [LCProgressHUD show:@"请输入验证码"];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [LCProgressHUD show:@"请输入密码"];
        return;
    }
    if (self.passwordTextField.text.length <6 || self.passwordTextField.text.length > 10) {
        [LCProgressHUD show:@"请输入正确格式的密码"];
        return;
    }
    if (self.surePasswordTextField.text.length == 0) {
        [LCProgressHUD show:@"请输入确认密码密码"];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.surePasswordTextField.text]) {
        [LCProgressHUD show:@"两次密码不一致，请检查"];
        return;
    }
    [self.checkCodeAPI loadData];
}

- (BLResetPasswordAPI *)resetPasswordAPI {
    if (!_resetPasswordAPI) {
        _resetPasswordAPI = [[BLResetPasswordAPI alloc] init];
        _resetPasswordAPI.mj_delegate = self;
        _resetPasswordAPI.paramSource = self;
    }
    return _resetPasswordAPI;
}

- (BLCheckCodeAPI *)checkCodeAPI {
    if (!_checkCodeAPI) {
        _checkCodeAPI = [[BLCheckCodeAPI alloc] init];
        _checkCodeAPI.paramSource = self;
        _checkCodeAPI.mj_delegate = self;
    }
    return _checkCodeAPI;
}

- (BLAppLoginRegisterSendCodeAPI *)appLoginRegisterSendCodeAPI {
    if (!_appLoginRegisterSendCodeAPI) {
        _appLoginRegisterSendCodeAPI = [[BLAppLoginRegisterSendCodeAPI alloc] init];
        _appLoginRegisterSendCodeAPI.mj_delegate = self;
        _appLoginRegisterSendCodeAPI.paramSource = self;
    }
    return _appLoginRegisterSendCodeAPI;
}

@end
