//
//  BLPersonalDataTableViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/29.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLPersonalDataTableViewController.h"
#import "ZLUserInstance.h"
#import "UIImagePickerController+NTAdd.h"
#import "ZLNetTool.h"
#import <LCProgressHUD.h>
#import "BLUpdateMemberInfoAPI.h"
#import <YYWebImage.h>

@interface BLPersonalDataTableViewController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (nonatomic, strong) BLUpdateMemberInfoAPI * updateMemberInfoAPI;

@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;
@property (nonatomic, copy) NSString *uploadObj;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, strong) UIImage *headImg;
@end

@implementation BLPersonalDataTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"ZLUserInfoUpdateNotificationKey" object:nil];

    [self userInfoUpdate];
    [self updateData];

}

- (void)userInfoUpdate {
//    [[ZLUserInstance sharedInstance] removeUserInfo];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateData {
    [_imageVIew yy_setImageWithURL:[NSURL URLWithString:[ZLUserInstance sharedInstance].photo] placeholder:[UIImage imageNamed:@"my_grzl_tx"]];
    self.nickNameLabel.text = [ZLUserInstance sharedInstance].nickname;
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"确定退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil]];
        __weak typeof(self) wself = self;
        [alertCon addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[ZLUserInstance sharedInstance] loginOutWithViewController:wself];
            [wself.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alertCon animated:YES completion:nil];
    }else if (indexPath.row == 0) {
        
        [UIImagePickerController nt_showImgaePickerWithType:NTImagePickerTypeChooseFromAlbum firstFrontCamera:NO showConfig:^(UIImagePickerController *picker) {
            picker.allowsEditing = YES;
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:picker animated:YES completion:nil];
        } completion:^(UIImage *selectImage) {
            
            if (!selectImage) {
                return;
            }
            self.headImg = selectImage;
            [LCProgressHUD showLoading];
            [ZLNetTool zl_upLoadWithImage:selectImage success:^(id  _Nullable obj) {
                
                if ([obj[@"code"] intValue] == 200) {
                    self.uploadObj = obj[@"data"];
                    [self.updateMemberInfoAPI loadData];
                }
                
                NSLog(@"%@", obj);
            } failure:^(NSError * _Nullable error) {
                [LCProgressHUD show:error.localizedDescription];
            }];
            
        } failed:^(NTImagePickerShowErrorType errorType) {
            
        }];
    }
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.updateMemberInfoAPI isEqual:manager]) {
        return @{@"photo" : self.uploadObj,
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
            [LCProgressHUD show:@"修改成功"];
            self.imageVIew.image = self.headImg;
            [[ZLUserInstance sharedInstance] setValue:_uploadObj forKey:@"photo"];
            [[NSNotificationCenter defaultCenter] postNotificationName:ZLUserInfoUpdateNotificationKey object:nil];
        }else{
            [LCProgressHUD show:@"修改失败"];
        }

    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
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
