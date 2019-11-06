//
//  BLModifyPhonTableViewController.m
//  BigLionEdu
//
//  Created by OrangesAL on 2019/10/8.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLModifyPhonTableViewController.h"
#import "BLSetModifyPhoneAPI.h"
#import "BLCheckCodeAPI.h"
#import "BLAppLoginRegisterSendCodeAPI.h"
#import "UIButton+YasinTimerCategory.h"
#import <LCProgressHUD.h>
#import "AdaptScreenHelp.h"

@interface BLModifyPhonTableViewController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@property (nonatomic, strong) BLSetModifyPhoneAPI *resetPasswordAPI;
@property (nonatomic, strong) BLCheckCodeAPI * checkCodeAPI;
@property (nonatomic, strong) BLAppLoginRegisterSendCodeAPI * appLoginRegisterSendCodeAPI;


@end

@implementation BLModifyPhonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
//    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 50, 35);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:217/255.0 blue:120/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0].CGColor];
    gl.cornerRadius = 17.5;
    gl.locations = @[@(0.0),@(1.0)];
    
    [_sureBtn.layer addSublayer:gl];
    [_sureBtn.layer insertSublayer:gl atIndex:0];
}


- (IBAction)action_code:(id)sender {
    if (self.phoneField.text.length == 0) {
        [LCProgressHUD show:@"请输入手机号码"];
        return;
    }
    if (self.phoneField.text.length != 11) {
        [LCProgressHUD show:@"请输入11位手机号码"];
        return;
    }
    self.appLoginRegisterSendCodeAPI.urlParams = @{@"mobile": self.phoneField.text?self.phoneField.text:@""};
    [self.appLoginRegisterSendCodeAPI loadData];
    [sender startCountDownTime:60 withCountDownBlock:^{
        
    }];
}

- (IBAction)action_sure:(id)sender {
    if (self.phoneField.text.length == 0) {
           [LCProgressHUD show:@"请输入手机号码"];
           return;
       }
       if (self.phoneField.text.length != 11) {
           [LCProgressHUD show:@"请输入11位手机号码"];
           return;
       }
       if (self.codeField.text.length == 0) {
           [LCProgressHUD show:@"请输入验证码"];
           return;
    }
    [self.resetPasswordAPI loadData];
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.resetPasswordAPI isEqual:manager]) {
        return @{@"mobile":_phoneField.text ? _phoneField.text: @""};
    }
    if ([self.checkCodeAPI isEqual:manager]) {
        return @{@"mobile": _phoneField.text?_phoneField.text:@"",
                 @"code": _codeField.text?_codeField.text:@""
                 };
    }
    if ([self.appLoginRegisterSendCodeAPI isEqual:manager]) {
        return @{@"mobile": _phoneField.text?_phoneField.text:@""};
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.resetPasswordAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [LCProgressHUD show:@"修改成功"];
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
             [self.codeField becomeFirstResponder];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (BLSetModifyPhoneAPI *)resetPasswordAPI {
    if (!_resetPasswordAPI) {
        _resetPasswordAPI = [[BLSetModifyPhoneAPI alloc] init];
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
