//
//  BLAddressListViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAddressListViewController.h"
#import "BLGetAddressListAPI.h"
#import <MJPlaceholder.h>
#import "ZLTableViewDelegateManager.h"
#import <YYModel.h>
#import "BLAddressModel.h"
#import "ZLUserInstance.h"
#import <MJRefresh.h>
#import "BLAddressListTableViewCell.h"
#import "BLDeleteAddresAPI.h"
#import "BLAddAddressViewController.h"

@interface BLAddressListViewController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource, BLAddressListTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager * manager;
@property (nonatomic, strong) BLGetAddressListAPI * getAddressListAPI;
@property (nonatomic, strong) BLDeleteAddresAPI * deleteAddresAPI;
@property (nonatomic, strong) NSArray * datas;
@property (nonatomic, strong) BLAddressModel *currentModel;

@end

@implementation BLAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.getAddressListAPI loadData];
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself.getAddressListAPI loadData];
    }];
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"还没添加收货地址哦",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.getAddressListAPI loadData];
}

#pragma mark -- BLAddressListTableViewCellDelegate
- (void)BLAddressListTableViewCellEdit:(BLAddressModel *)model {
    self.currentModel = model;
    if (!self.addressId) {
        NSDictionary *dict = [model yy_modelToJSONObject];
        BLAddAddressViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLAddAddressViewController"];
        viewController.address = dict;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)BLAddressListTableViewCellDelete:(BLAddressModel *)model {
    self.currentModel = model;
    if (!self.addressId) {
        [self.deleteAddresAPI loadData];
    }
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getAddressListAPI isEqual:manager]) {
        return @{@"memberId": @([ZLUserInstance sharedInstance].Id)};
    } else if ([self.deleteAddresAPI isEqual:manager]) {
        return @{@"id": @(self.currentModel.Id)};
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getAddressListAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [self.tableView.mj_header endRefreshing];
            ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
            NSMutableArray *datas = [NSMutableArray array];
            sectionModel.items = datas;
            NSArray *models = [NSArray yy_modelArrayWithClass:[BLAddressModel class] json:[data objectForKey:@"data"]];
            [models enumerateObjectsUsingBlock:^(BLAddressModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (self.addressId && self.addressId == obj.Id) {
                    obj.selected = YES;
                }
                
                [datas addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLAddressListTableViewCell";
                    rowModel.data = obj;
                    rowModel.cellHeight = 75;
                    rowModel.delegate = self;
                    rowModel;
                })];
            }];
            self.datas = @[sectionModel];
            [self.manager reloadData];
        }
    } else if ([self.deleteAddresAPI isEqual:manager]) {
        [self.getAddressListAPI loadData];
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
}

#pragma mark -- ZLTableViewDelegateManagerDelegate
- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return self.datas;
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    BLAddressModel *address = model.data;
    if (address.selected) {
        return;
    }
    if (self.didSelectAddressBlock) {
        self.didSelectAddressBlock([model.data yy_modelToJSONObject]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (BLGetAddressListAPI *)getAddressListAPI {
    if (!_getAddressListAPI) {
        _getAddressListAPI = ({
            BLGetAddressListAPI * api = [[BLGetAddressListAPI alloc] init];
            api.mj_delegate = self;
            api.paramSource = self;
            api;
        });
    }
    return _getAddressListAPI;
}

- (BLDeleteAddresAPI *)deleteAddresAPI {
    if (!_deleteAddresAPI) {
        _deleteAddresAPI = ({
            BLDeleteAddresAPI * api = [[BLDeleteAddresAPI alloc] init];
            api.mj_delegate = self;
            api.paramSource = self;
            api;
        });
    }
    return _deleteAddresAPI;
}

@end
