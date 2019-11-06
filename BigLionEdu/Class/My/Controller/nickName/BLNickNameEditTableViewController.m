//
//  BLNickNameEditTableViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLNickNameEditTableViewController.h"
#import "BLUpdateMemberInfoAPI.h"
#import "ZLUserInstance.h"
#import <LCProgressHUD.h>

@interface BLNickNameEditTableViewController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (nonatomic, strong) BLUpdateMemberInfoAPI * updateMemberInfoAPI;
@end

@implementation BLNickNameEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    _textfield.text = [ZLUserInstance sharedInstance].nickname;
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.updateMemberInfoAPI isEqual:manager]) {
        return @{@"nickname": _textfield.text ? _textfield.text : @"",
                 @"id":@([ZLUserInstance sharedInstance].Id)
                 };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.updateMemberInfoAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [[ZLUserInstance sharedInstance] setValue:_textfield.text?_textfield.text:@"" forKey:@"nickname"];
            [[NSNotificationCenter defaultCenter] postNotificationName:ZLUserInfoUpdateNotificationKey object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [LCProgressHUD show:@"修改失败"];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (IBAction)saveEvent:(id)sender {
    if (_textfield.text.length == 0) {
        [LCProgressHUD show:@"请输入昵称"];
        return;
    }
    if (_textfield.text.length > 30) {
        [LCProgressHUD show:@"昵称最多30个字符"];
        return;
    }
    [self.updateMemberInfoAPI loadData];
}


- (BLUpdateMemberInfoAPI *)updateMemberInfoAPI {
    if (!_updateMemberInfoAPI) {
        _updateMemberInfoAPI = ({
            BLUpdateMemberInfoAPI * api = [[BLUpdateMemberInfoAPI alloc] init];
            api.mj_delegate = self;
            api.paramSource = self;
            api;
        });
    }
    return _updateMemberInfoAPI;
}

@end
