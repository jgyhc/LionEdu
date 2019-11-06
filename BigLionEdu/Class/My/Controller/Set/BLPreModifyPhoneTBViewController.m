//
//  BLPreModifyPhoneTBViewController.m
//  BigLionEdu
//
//  Created by OrangesAL on 2019/10/8.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLPreModifyPhoneTBViewController.h"
#import "BLSetModifyPhoneAPI.h"
#import <LCProgressHUD.h>

@interface BLPreModifyPhoneTBViewController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic, strong) BLSetcheckPasswordAPI *checkAPi;


@end

@implementation BLPreModifyPhoneTBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, self.sureBtn.bounds.size.width, 35);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:217/255.0 blue:120/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0].CGColor];
    gl.cornerRadius = 17.5;
    gl.locations = @[@(0.0),@(1.0)];
    
    [_sureBtn.layer addSublayer:gl];
    [_sureBtn.layer insertSublayer:gl atIndex:0];
}

- (IBAction)action_nextstep:(id)sender {
    
    if (self.passwordTextField.text.length == 0) {
       [LCProgressHUD show:@"请输入密码"];
       return;
    }
    [self.checkAPi loadData];
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    return @{@"password" : _passwordTextField.text};
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    if (code == 200) {
//        [LCProgressHUD show:@"修改成功，请重新登录"];
        
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLModifyPhonTableViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (BLSetcheckPasswordAPI *)checkAPi {
    if (!_checkAPi) {
        _checkAPi = [[BLSetcheckPasswordAPI alloc] init];
        _checkAPi.mj_delegate = self;
        _checkAPi.paramSource = self;
    }
    return _checkAPi;
}

@end
