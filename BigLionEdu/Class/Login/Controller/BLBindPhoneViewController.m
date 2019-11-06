//
//  BLBindPhoneViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/20.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLBindPhoneViewController.h"
#import "BLBingdingTableViewCell.h"
#import "ZLTableViewDelegateManager.h"

@interface BLBindPhoneViewController ()<ZLTableViewDelegateManagerDelegate, BLBingdingTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;

@end

@implementation BLBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W04" size:19]}];
    [self.view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1]];
    
    [self.manager reloadData];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        sectionModel.items = @[({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.cellHeight = 500;
            rowModel.identifier = @"BLBingdingTableViewCell";
            rowModel.delegate = self;
            rowModel.data = _openid;
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
