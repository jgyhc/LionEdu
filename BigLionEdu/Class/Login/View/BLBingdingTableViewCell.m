//
//  BLBingdingTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLBingdingTableViewCell.h"
#import "BLAppLoginRegisterSendCodeAPI.h"
#import "BLBindingMobileAPI.h"
#import "UIButton+YasinTimerCategory.h"
#import <LCProgressHUD.h>
#import "BLCheckCodeAPI.h"
#import "AdaptScreenHelp.h"
#import "ZLUserInstance.h"
#import "BLGetAllModelAPI.h"
#import <YYModel.h>
#import "BLGetAllModel.h"
#import "YZTagList.h"
#import <Masonry.h>
#import "UIColor+MJRGBCategory.h"

@interface BLBingdingTableViewCell ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *conView;


@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *invitePhoneTextField;

//@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) BLAppLoginRegisterSendCodeAPI * appLoginRegisterSendCodeAPI;
@property (weak, nonatomic) IBOutlet UIImageView *agreementButton;
@property (weak, nonatomic) IBOutlet UIButton *agreementSelectButton;

@property (nonatomic, strong) BLBindingMobileAPI * bindingMobileAPI;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagHeight;

@property (nonatomic, strong) BLCheckCodeAPI * checkCodeAPI;
@property (nonatomic, strong) BLGetAllModelAPI *getAllModelAPI;
@property (nonatomic, assign) BOOL isReadingAgreement;
@property (nonatomic, strong) YZTagList *tagList;
@property (nonatomic, strong) NSArray *tags;
@end

@implementation BLBingdingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _isReadingAgreement = YES;
    [self.conView layoutIfNeeded];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 70, 35);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:217/255.0 blue:120/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0].CGColor];
    gl.cornerRadius = 17.5;
    gl.locations = @[@(0.0),@(1.0)];
    //    [self.loginButton setTitle:@"登录并注册" forState:UIControlStateNormal];
    
    [_loginButton.layer addSublayer:gl];
    [_loginButton.layer insertSublayer:gl atIndex:0];
//    [self.getAllModelAPI loadData];
//    [self.tagView addSubview:self.tagList];
//    [self.tagList mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    // Initialization code
}

- (void)setNormalWithButton:(UIButton *)sender {
    sender.layer.borderColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0].CGColor;
    sender.layer.borderWidth = 1;
}

- (void)setSelectWithButton:(UIButton *)sender {
    sender.layer.borderColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0].CGColor;
    sender.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)agreementEvent:(id)sender {
}

- (IBAction)selectAgreementEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
    _isReadingAgreement = sender.selected;
}


- (IBAction)buttonEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self setSelectWithButton:sender];
    }else {
        [self setNormalWithButton:sender];
    }
    
}

- (IBAction)getCodeEvent:(UIButton *)sender {
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


- (IBAction)backEvent:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backViewController)]) {
        [self.delegate backViewController];
    }
}


- (IBAction)loginButton:(id)sender {
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
//    if (self.passwordTextField.text.length == 0) {
//        [LCProgressHUD show:@"请输入密码"];
//        return;
//    }
//    if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 10) {
//        [LCProgressHUD show:@"请输入正确格式的密码"];
//        return;
//    }
//    if (self.surePasswordTextField.text.length == 0) {
//        [LCProgressHUD show:@"请输入确认密码密码"];
//        return;
//    }
//    if (![self.passwordTextField.text isEqualToString:self.surePasswordTextField.text]) {
//        [LCProgressHUD show:@"两次密码不一致，请检查"];
//        return;
//    }
    if (!_isReadingAgreement) {
        [LCProgressHUD show:@"请认真阅读大狮解用户协议"];
        return;
    }
//    NSMutableArray *ids = [NSMutableArray array];
//    [_tags enumerateObjectsUsingBlock:^(BLGetAllModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.selected) {
//            [ids addObject:@(obj.Id)];
//        }
//    }];
//    if (ids.count == 0) {
//        [LCProgressHUD show:@"请至少选择一项兴趣"];
//        return;
//    }
    [self.checkCodeAPI loadData];
    
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.appLoginRegisterSendCodeAPI isEqual:manager]) {
        return @{@"mobile": _phoneTextField.text?_phoneTextField.text:@""};
    }
    if ([self.bindingMobileAPI isEqual:manager]) {
        
        return @{@"openid":_model?_model:@"",
                 @"mobile": _phoneTextField.text?_phoneTextField.text:@""
                 };
    }
    if ([self.checkCodeAPI isEqual:manager]) {
        return @{@"mobile": _phoneTextField.text?_phoneTextField.text:@"",
                 @"code": _codeTextField.text?_codeTextField.text:@""
                 };
    }
    return nil;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getAllModelAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray *tags = [NSArray yy_modelArrayWithClass:[BLGetAllModel class] json:[data objectForKey:@"data"]];
            _tags = tags;
            [tags enumerateObjectsUsingBlock:^(BLGetAllModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.tagList addTag:obj.title];
            }];
            self.tagHeight.constant = self.tagList.tagListH;
            [self.tagView layoutIfNeeded];
        }
    }
    if ([self.appLoginRegisterSendCodeAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [self.codeTextField becomeFirstResponder];
        }
    }
    if ([self.checkCodeAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            
            [self.bindingMobileAPI loadData];
        }
    }
    if ([self.bindingMobileAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            
            NSDictionary *model = [data objectForKey:@"data"];
            if ([model isKindOfClass:[NSDictionary class]]) {
                NSDictionary *userInfo = [model objectForKey:@"userInfo"];
                NSString *token = [model objectForKey:@"token"];
                [[ZLUserInstance sharedInstance] setValue:token?token:@"" forKey:@"token"];
                [[ZLUserInstance sharedInstance] loginWithUserInfo:userInfo];
            }else {
                [[ZLUserInstance sharedInstance] loginWithToken:[data objectForKey:@"data"]];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(dissMissViewController)]) {
                [self.delegate dissMissViewController];
            }
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (void)normalButton:(UIButton *)sender {
    sender.layer.borderColor = [UIColor colorWithHexString:@"#898B94"].CGColor;
    [sender setTitleColor:[UIColor colorWithHexString:@"#ACACAC"] forState:UIControlStateNormal];
}

- (void)selectButton:(UIButton *)sender {
    sender.layer.borderColor = [UIColor colorWithHexString:@"#FF7349"].CGColor;
    [sender setTitleColor:[UIColor colorWithHexString:@"#FF7349"] forState:UIControlStateNormal];
}


- (BLAppLoginRegisterSendCodeAPI *)appLoginRegisterSendCodeAPI {
    if (!_appLoginRegisterSendCodeAPI) {
        _appLoginRegisterSendCodeAPI = [[BLAppLoginRegisterSendCodeAPI alloc] init];
        _appLoginRegisterSendCodeAPI.mj_delegate = self;
        _appLoginRegisterSendCodeAPI.paramSource = self;
    }
    return _appLoginRegisterSendCodeAPI;
}

- (BLBindingMobileAPI *)bindingMobileAPI {
    if (!_bindingMobileAPI){
        _bindingMobileAPI = ({
            BLBindingMobileAPI * api = [[BLBindingMobileAPI alloc] init];
            api.mj_delegate = self;
            api.paramSource = self;
            api;
        });
    }
    return _bindingMobileAPI;
}

- (BLCheckCodeAPI *)checkCodeAPI {
    if (!_checkCodeAPI) {
        _checkCodeAPI = ({
            BLCheckCodeAPI * api = [[BLCheckCodeAPI alloc] init];
            api.mj_delegate = self;
            api.paramSource = self;
            api;
        });;
    }
    return _checkCodeAPI;
}

- (BLGetAllModelAPI *)getAllModelAPI {
    if (!_getAllModelAPI) {
        _getAllModelAPI = [[BLGetAllModelAPI alloc] init];
        _getAllModelAPI.mj_delegate = self;
        _getAllModelAPI.paramSource = self;
    }
    return _getAllModelAPI;
}

- (YZTagList *)tagList {
    if (!_tagList) {
        _tagList = [[YZTagList alloc] init];
        _tagList.tagCornerRadius = 3;
        _tagList.borderWidth = 0.6;
        _tagList.borderColor = [UIColor colorWithHexString:@"#898B94"];
        _tagList.tagFont = [UIFont systemFontOfSize:12];
        _tagList.tagColor = [UIColor colorWithHexString:@"#ACACAC"];
        _tagList.lineSpacing = 13;
        _tagList.interitemSpacing = 15;
        _tagList.tagListH = 21;
        __weak typeof(self) wself = self;
        [_tagList setClickTagBlock:^(UIButton *button, NSString *tag) {
            __block BLGetAllModel *currentModel;
            [wself.tags enumerateObjectsUsingBlock:^(BLGetAllModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([tag isEqualToString:obj.title]) {
                    currentModel = obj;
                    *stop = YES;
                }
            }];
            if (currentModel.selected) {
                [wself normalButton:button];
                currentModel.selected = NO;
            }else {
                [wself selectButton:button];
                currentModel.selected = YES;
            }
        }];
    }
    return _tagList;
}

@end
