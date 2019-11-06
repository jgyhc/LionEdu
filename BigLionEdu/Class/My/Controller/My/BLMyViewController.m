//  我的主界面
//  BLMyViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyViewController.h"
#import "ZLTableViewDelegateManager.h"
#import <MJRefresh.h>
#import <YYModel.h>
#import <MJPlaceholder.h>
#import "AdaptScreenHelp.h"
#import "BLTextAlertViewController.h"
#import "BLCouponViewController.h"
#import "BLTextAlertViewController.h"
#import "UIViewController+ZLCustomNavigationBar.h"
#import "BLAPPMyselfGetAppMemberGradeInfoAPI.h"
#import "BLAPPMyselfGetMemberInfoAPI.h"
#import "ZLUserInstance.h"
#import "BLMyUserInfoModel.h"
#import <LCProgressHUD.h>

@interface BLMyViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic, strong) <#APIClass#> *<#apiName#>;

//@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) BLAPPMyselfGetAppMemberGradeInfoAPI *appMyselfGetAppMemberGradeInfoAPI;

@property (nonatomic, strong) BLAPPMyselfGetMemberInfoAPI *appMyselfGetMemberInfoAPI;

@end

@implementation BLMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.appMyselfGetMemberInfoAPI loadData];
    self.customNavigationBar = [ZLCustomNavigationBar new];
    [self.customNavigationBar addButtonWithImage:[UIImage imageNamed:@"my_xx"] target:self action:@selector(handleMessageEvent)];
    self.customNavigationBar.leftButton.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.datas addObject:({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        NSMutableArray *items = [NSMutableArray array];
        sectionModel.items = items;
        [items addObject:({
            ZLTableViewRowModel *row = [ZLTableViewRowModel new];
            row.identifier = @"BLMyHeaderTableViewCell";
            row.cellHeight = 151 + StatusBarHeight();
            row.data = [ZLUserInstance sharedInstance];
            row;
        })];
        
        [items addObject:({
            ZLTableViewRowModel *row = [ZLTableViewRowModel new];
            row.identifier = @"BLMymenuTableViewCell";
            row.cellHeight = 86;
            row;
        })];
        
        [items addObject:({
            ZLTableViewRowModel *row = [ZLTableViewRowModel new];
            row.identifier = @"BLCircularTableViewCell";
            row.cellHeight = 10;
            row;
        })];
        
        
        [items addObject:({
            ZLTableViewRowModel *row = [ZLTableViewRowModel new];
            row.identifier = @"BLMyItemTableViewCell";
            row.cellHeight = 45;
            row.data = @{@"title": @"我的套餐",
                         @"icon": @"my_tc"
                         };
            row;
        })];
        [items addObject:({
            ZLTableViewRowModel *row = [ZLTableViewRowModel new];
            row.identifier = @"BLMyItemTableViewCell";
            row.cellHeight = 45;
            row.data = @{@"title": @"题目收藏",
                         @"icon": @"my_tmsc"
                         };
            row;
        })];
        
        [items addObject:({
            ZLTableViewRowModel *row = [ZLTableViewRowModel new];
            row.identifier = @"BLMyItemTableViewCell";
            row.cellHeight = 45;
            row.data = @{@"title": @"答题记录",
                         @"icon": @"my_dtjl"
                         };
            row;
        })];
        
        [items addObject:({
            ZLTableViewRowModel *row = [ZLTableViewRowModel new];
            row.identifier = @"BLMyItemTableViewCell";
            row.cellHeight = 45;
            row.data = @{@"title": @"我的订单",
                         @"icon": @"my_wddd"
                         };
            row;
        })];
        
        [items addObject:({
            ZLTableViewRowModel *row = [ZLTableViewRowModel new];
            row.identifier = @"BLMyItemTableViewCell";
            row.cellHeight = 45;
            row.data = @{@"title": @"下载课程",
                         @"icon": @"my_xzdkc"
                         };
            row;
        })];
        
        [items addObject:({
            ZLTableViewRowModel *row = [ZLTableViewRowModel new];
            row.identifier = @"BLMyItemTableViewCell";
            row.cellHeight = 45;
            row.data = @{@"title": @"联系我们",
                         @"icon": @"my_rxdh"
                         };
            row;
        })];
        
        
        [items addObject:({
            ZLTableViewRowModel *row = [ZLTableViewRowModel new];
            row.identifier = @"BLMyItemTableViewCell";
            row.cellHeight = 45;
            row.data = @{@"title": @"设置",
                         @"icon": @"my_sz"
                         };
            row;
        })];
        
        [items addObject:({
            ZLTableViewRowModel *row = [ZLTableViewRowModel new];
            row.identifier = @"BLBottomCircularTableViewCell";
            row.cellHeight = 10;
            row;
        })];
        
        sectionModel;
    })];
    [self.manager reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ZLUserInstance sharedInstance].isLogin) {
//        [self.appMyselfGetAppMemberGradeInfoAPI loadData];
        [self.appMyselfGetMemberInfoAPI loadData];
    }
}

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.appMyselfGetMemberInfoAPI isEqual:manager]) {
    }
    // 获取用户信息
//    if ([self.appMyselfGetMemberInfoAPI isEqual:manager]) {
//        return @{@"Id":@([ZLUserInstance sharedInstance].Id)};
//    }
    return nil;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data{
    NSInteger code =[[data objectForKey:@"code"] integerValue];
    if (code !=200) {
        return;
    }
    if ([manager isEqual:self.appMyselfGetMemberInfoAPI]) {
        [[ZLUserInstance sharedInstance] separateUpdateUserInfo:[data objectForKey:@"data"]];
        [self.tableView reloadData];
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (void)handleMessageEvent {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMessageTypeTableViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

#pragma mark -- ZLTableViewDelegateManagerDelegate method
- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return self.datas;
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    if (indexPath.row == 0 && indexPath.section == 0) {
        [self performSegueWithIdentifier:@"ToBLPersonalDataTableViewController" sender:nil];
        return;
    }
    id data = model.data;
    if (indexPath.row == 0 && indexPath.section == 0) {
        [self performSegueWithIdentifier:@"ToBLPersonalDataTableViewController" sender:nil];
        return;
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSString *title = [data objectForKey:@"title"];
        if ([title isEqualToString:@"设置"]) {
            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLSetTableViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        if ([title isEqualToString:@"题目收藏"]) {
            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMyCollectViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        if ([title isEqualToString:@"答题记录"]) {
            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLRecordViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        if ([title isEqualToString:@"我的订单"]) {
            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLOrderListViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        if ([title isEqualToString:@"下载课程"]) {
            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLOfflineVideoTableViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        if ([title isEqualToString:@"我的套餐"]) {
            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMealViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        if ([title isEqualToString:@"联系我们"]) {
            BLTextAlertViewController *viewController = [[BLTextAlertViewController alloc] initWithTitle:@"联系我们" content:@"专升本热线电话：18254785141\n\n公务员热线电话：13457845785\n\n 事业单位联系QQ：598754565\n\n教师招聘联系QQ：496785478\n\n教师资格证热线电话：18578457854\n\n计算机和英语等级热线电话：18578457854" buttons:@[@"知道了"] tapBlock:^(BLTextAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
        
            }];
            
            viewController = [NSClassFromString(@"BLContactUSController") new];
            [self.tabBarController presentViewController:viewController animated:YES completion:nil] ;
        }
        
    }
}

//优惠券
- (IBAction)couponEvent:(id)sender {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMyCouponsViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

/** 我的兴趣 */
- (IBAction)interestEvent:(id)sender {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMyInterestViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

/** 我的课程 */
- (IBAction)classEvent:(id)sender {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMyClassViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

/** 错题本 */
- (IBAction)wrongEvent:(id)sender {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMistakesViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BLAPPMyselfGetAppMemberGradeInfoAPI *)appMyselfGetAppMemberGradeInfoAPI{
    if (!_appMyselfGetAppMemberGradeInfoAPI) {
        _appMyselfGetAppMemberGradeInfoAPI =[[BLAPPMyselfGetAppMemberGradeInfoAPI alloc]init];
        _appMyselfGetAppMemberGradeInfoAPI.mj_delegate =self;
        _appMyselfGetAppMemberGradeInfoAPI.paramSource =self;

    }
    return _appMyselfGetAppMemberGradeInfoAPI;
}


- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (BLAPPMyselfGetMemberInfoAPI *)appMyselfGetMemberInfoAPI{
    if (!_appMyselfGetMemberInfoAPI) {
        _appMyselfGetMemberInfoAPI =[[BLAPPMyselfGetMemberInfoAPI alloc]init];
        _appMyselfGetMemberInfoAPI.mj_delegate =self;
        _appMyselfGetMemberInfoAPI.paramSource =self;
    }
    return _appMyselfGetMemberInfoAPI;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"ToBLPersonalDataTableViewController"]) {
//        if (![ZLUserInstance sharedInstance].isLogin) {
//            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
//            [self presentViewController:viewController animated:YES completion:nil];
//            return;
//        }
//    }
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    if ([identifier isEqualToString:@"ToBLPersonalDataTableViewController"]) {
        if (![ZLUserInstance sharedInstance].isLogin) {
            [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
            return NO;
        }
    }
    return YES;
}

@end
