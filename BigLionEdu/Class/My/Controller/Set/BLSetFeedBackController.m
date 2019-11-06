//
//  BLSetFeedBackController.m
//  BigLionEdu
//
//  Created by OrangesAL on 2019/10/8.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLSetFeedBackController.h"
#import "BLSetModuleAPI.h"
#import "UIViewController+ORAdd.h"
#import <LCProgressHUD.h>

@interface BLSetFeedBackController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (weak, nonatomic) IBOutlet UITextField *contactField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) BLSetModuleFeedBackAPI *api;

@end

@implementation BLSetFeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"意见反馈";
}
- (IBAction)action_commit:(id)sender {
    
    if (self.textView.text.length == 0) {
       [LCProgressHUD show:@"请输入反馈内容"];
       return;
    }
    if (self.contactField.text.length == 0) {
       [LCProgressHUD show:@"请输入联系方式"];
       return;
    }
    [self.api loadData];
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    
    NSInteger type = [_titleLabel.text isEqualToString:@"意见反馈"] ? 2 : 1;
    
    return @{@"contact" : _contactField.text,
             @"content" : _textView.text,
             @"type" : @(type)
    };
    
//    return @{@"password" : _passwordTextField.text};
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    if (code == 200) {
        [LCProgressHUD show:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (BLSetModuleFeedBackAPI *)api {
    if (!_api) {
        _api = [[BLSetModuleFeedBackAPI alloc] init];
        _api.mj_delegate = self;
        _api.paramSource = self;
    }
    return _api;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        [self or_showAlert:@"请选择" message:@"反馈类型" actionTitles:@[@"意见反馈", @"系统反馈"] style:UIAlertControllerStyleActionSheet completion:^(NSInteger index) {
            self.titleLabel.text = index == 0 ? @"意见反馈" : @"系统反馈";
        }];
    }
}

@end
