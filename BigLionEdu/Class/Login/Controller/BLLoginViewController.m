//
//  BLLoginViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/20.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLLoginViewController.h"
#import "BLRegisterViewController.h"
#import "BLAppLoginAPI.h"
#import <LCProgressHUD.h>
#import "AdaptScreenHelp.h"
#import "ZLUserInstance.h"
#import "MJWeChatSDK.h"
#import "BLWeChatLoginAPI.h"
#import "BLBindPhoneViewController.h"
#import "UITextField+BLCustomFont.h"
#import "NTCatergory.h"

@interface BLLoginViewController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) BLAppLoginAPI *appLoginAPI;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace2;

@property (nonatomic, strong) BLWeChatLoginAPI *weChatLoginAPI;

@property (nonatomic, copy) NSString *code;//微信登录t用的code

@end

@implementation BLLoginViewController

- (void)dealloc {
    [[CTMediator sharedInstance] performTarget:@"login" action:@"resetStatus" params:nil shouldCacheTarget:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1]];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _topSpace.constant = flexibleHeight(60);
    _bottomSpace.constant = flexibleHeight(29);
    _topSpace1.constant = flexibleHeight(120);
    _space1.constant = flexibleHeight(36);
    _space.constant = flexibleHeight(60);
    _topSpace2.constant = flexibleHeight(52);
    _space2.constant = flexibleHeight(45);
    _bottomSpace2.constant  =flexibleHeight(29);
    [self.contentView layoutIfNeeded];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, self.loginButton.bounds.size.width, 35);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:217/255.0 blue:120/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0].CGColor];
    gl.cornerRadius = 17.5;
    gl.locations = @[@(0.0),@(1.0)];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [_loginButton.layer addSublayer:gl];
    [_loginButton.layer insertSublayer:gl atIndex:0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W04" size:19]}];
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W04" size:19]}];
}

- (IBAction)loginEvent:(id)sender {
    if (self.phoneTextField.text.length == 0) {
        [LCProgressHUD show:@"请输入手机号码"];
        return;
    }
    if (self.phoneTextField.text.length != 11) {
        [LCProgressHUD show:@"请输入11位手机号码"];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [LCProgressHUD show:@"请输入密码"];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [LCProgressHUD show:@"请输入密码"];
        return;
    }
    [self.appLoginAPI loadData];
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = [mainStoryboard instantiateInitialViewController];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)regiseEvent:(id)sender {
    
}

- (IBAction)passwordEvent:(id)sender {
    
}

- (IBAction)closeEvent:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)weCahtEvent:(id)sender {
    __weak typeof(self) wself = self;
    [[MJWeChatSDK shareInstance] sendWeixinLoginRequestWithViewController:self resultBlock:nil codeResultBlock:^(NSString * _Nonnull code) {
        wself.code = code;
        [wself.weChatLoginAPI loadData];
    }];
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.appLoginAPI isEqual:manager]) {
        return @{@"password":_passwordTextField.text?_passwordTextField.text:@"",
                 @"username":_phoneTextField.text?_phoneTextField.text : @"",
                 @"isApp":@"1"
                 };
    }
    if ([self.weChatLoginAPI isEqual:manager]) {
        return @{
                 @"code":_code?_code:@""
                 };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.appLoginAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [[ZLUserInstance sharedInstance] loginWithToken:[data objectForKey:@"data"]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    if ([self.weChatLoginAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSDictionary *info = [data objectForKey:@"data"];
            NSInteger state = [[info objectForKey:@"state"] integerValue];
            NSString *openid = [info objectForKey:@"openid"];
            if (state == 1) {
                BLRegisterViewController *viewController = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLRegisterViewController"];
                viewController.openID = openid;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            if (state == 2) {
                [[ZLUserInstance sharedInstance] loginWithToken:[info objectForKey:@"token"]];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (BLAppLoginAPI *)appLoginAPI {
    if (!_appLoginAPI) {
        _appLoginAPI = [[BLAppLoginAPI alloc] init];
        _appLoginAPI.mj_delegate = self;
        _appLoginAPI.paramSource = self;
    }
    return _appLoginAPI;
}

- (BLWeChatLoginAPI *)weChatLoginAPI {
    if (!_weChatLoginAPI) {
        _weChatLoginAPI = [[BLWeChatLoginAPI alloc] init];
        _weChatLoginAPI.mj_delegate = self;
        _weChatLoginAPI.paramSource = self;
    }
    return _weChatLoginAPI;
}
@end
