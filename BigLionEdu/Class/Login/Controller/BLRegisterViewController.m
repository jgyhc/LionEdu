//
//  BLRegisterViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/20.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLRegisterViewController.h"
#import "BLRegisterTableViewCell.h"
#import "ZLTableViewDelegateManager.h"
#import "BLBindPhoneViewController.h"

@interface BLRegisterViewController ()<ZLTableViewDelegateManagerDelegate, BLRegisterTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;


@end

@implementation BLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W04" size:19]}];
    [self.view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1]];
    
    [self.manager reloadData];
    
    if (self.openID) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"已有账号？直接绑定" style:UIBarButtonItemStylePlain target:self action:@selector(action_bindPhone)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        self.title = @"完善信息";
    }
}

- (void)action_bindPhone {
    BLBindPhoneViewController *viewController = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLBindPhoneViewController"];
    viewController.openid = self.openID;
    [self.navigationController pushViewController:viewController animated:YES];

}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        sectionModel.items = @[({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.cellHeight = -1;
            rowModel.identifier = @"BLRegisterTableViewCell";
            rowModel.delegate = self;
            rowModel.data = self.openID;
            rowModel;
        })];
        sectionModel;
    })];
}

- (void)dissMissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.tableView = self.tableView;
        _manager.delegate = self;
    }
    return _manager;
}



@end
