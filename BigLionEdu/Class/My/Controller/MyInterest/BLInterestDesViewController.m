//
//  BLInterestDesViewController.m
//  BigLionEdu
//
//  Created by mac on 2019/8/30.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLInterestDesViewController.h"
#import "BLAPPMyselfGetAppMemberGradeInfoAPI.h"

@interface BLInterestDesViewController ()<MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (nonatomic, strong) BLAPPMyselfGetAppMemberGradeInfoAPI *appMyselfGetAppMemberGradeInfoAPI;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation BLInterestDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentLabel.text = @"";
    [self.appMyselfGetAppMemberGradeInfoAPI loadData];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    return nil;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data{
    NSInteger code =[[data objectForKey:@"code"] integerValue];
    if (code !=200) {
        return;
    }
    if ([manager isEqual:self.appMyselfGetAppMemberGradeInfoAPI]) {
//        [[ZLUserInstance sharedInstance] separateUpdateUserInfo:[data objectForKey:@"data"]];
//        [self.tableView reloadData];
        _contentLabel.text = data[@"data"][@"content"];
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}



- (BLAPPMyselfGetAppMemberGradeInfoAPI *)appMyselfGetAppMemberGradeInfoAPI{
    if (!_appMyselfGetAppMemberGradeInfoAPI) {
        _appMyselfGetAppMemberGradeInfoAPI =[[BLAPPMyselfGetAppMemberGradeInfoAPI alloc]init];
        _appMyselfGetAppMemberGradeInfoAPI.mj_delegate =self;
        _appMyselfGetAppMemberGradeInfoAPI.paramSource =self;

    }
    return _appMyselfGetAppMemberGradeInfoAPI;
}



@end
