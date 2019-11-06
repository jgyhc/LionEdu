//
//  BLMyClassTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderListTableViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLGetOrderListAPI.h"
#import "BLOrderModel.h"
#import <YYModel.h>
#import "BLOrderHeaderCell.h"
#import "BLOrderGoodsCell.h"
#import "BLOrderFooterCell.h"
#import "NTCatergory.h"
#import "MJPlaceholderView.h"
#import <MJRefresh.h>
#import <MJPlaceholder.h>
#import "BLOrderDetailViewController.h"
#import "BLDeleteOrderAPI.h"
#import "BLCancelOrderAPI.h"
#import "BLRePayViewController.h"
#import "BLReturnPayAPI.h"
#import "BLTextAlertViewController.h"

@interface BLOrderListTableViewController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource, BLOrderFooterCellDelegate>

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) BLGetOrderListAPI *getOrderListAPI;
@property (nonatomic, strong) BLDeleteOrderAPI *deleteOrderAPI;
@property (nonatomic, strong) BLCancelOrderAPI *cancelOrderAPI;
@property (nonatomic, strong) BLReturnPayAPI *returnPayAPI;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) BLOrderModel *currentModel;

@end

@implementation BLOrderListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"BLOrderHeaderCell" bundle:nil] forCellReuseIdentifier:@"BLOrderHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BLOrderGoodsCell" bundle:nil] forCellReuseIdentifier:@"BLOrderGoodsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BLOrderFooterCell" bundle:nil] forCellReuseIdentifier:@"BLOrderFooterCell"];
    self.tableView.backgroundColor = [UIColor nt_colorWithHexString:@"#F9F9FA"];
    self.pageNum = 1;
    self.datas = [NSMutableArray array];
    [self.manager reloadData];
    [self.getOrderListAPI loadData];
    
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.pageNum = 1;
        [wself.getOrderListAPI loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        wself.pageNum += 1;
        [wself.getOrderListAPI loadData];
    }];
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"内容出走了，正在努力寻找中…",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
}

- (UIView *)listView {
    return self.view;
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return self.datas;
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    BLOrderDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLOrderDetailViewController"];
    if ([model.data isKindOfClass:[BLOrderGoodsModel class]]) {
        BLOrderGoodsModel *goods = model.data;
        viewController.goodsId = goods.orderId;
        viewController.singleType = goods.singleType;
    } else {
        BLOrderModel *goods = model.data;
        viewController.goodsId = goods.Id;
        viewController.singleType = goods.singleType;
    }
    [self.superViewController.navigationController pushViewController:viewController animated:YES];
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [data[@"code"] integerValue];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if ([manager isEqual:self.getOrderListAPI] && code == 200) {
        if (self.pageNum == 1) {
            [self.datas removeAllObjects];
        }
        NSArray <BLOrderModel *> *arr = [NSArray yy_modelArrayWithClass:[BLOrderModel class] json:data[@"data"][@"list"]];
        if (self.pageNum == 1 && arr.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        for (NSInteger i = 0; i < arr.count; i ++) {
            ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
            sectionModel.headerHeight = 15.0;
            sectionModel.headerBackgroundColor = [UIColor nt_colorWithHexString:@"#F9F9FA"];
            NSMutableArray *items = [NSMutableArray array];
            
            ZLTableViewRowModel *headerRow = [ZLTableViewRowModel new];
            headerRow.identifier = @"BLOrderHeaderCell";
            headerRow.cellHeight = 40.0;
            headerRow.data = arr[i];
            [items addObject:headerRow];
            for (NSInteger j = 0; j < arr[i].orderGoodsList.count; j ++) {
                ZLTableViewRowModel *goodsRow = [ZLTableViewRowModel new];
                goodsRow.identifier = @"BLOrderGoodsCell";
                goodsRow.cellHeight = 110.0;
                goodsRow.data = arr[i].orderGoodsList[j];
                [items addObject:goodsRow];
            }
            if (arr[i].status.integerValue != 2) {
                ZLTableViewRowModel *footerRow = [ZLTableViewRowModel new];
                footerRow.identifier = @"BLOrderFooterCell";
                footerRow.cellHeight = 40.0;
                footerRow.data = arr[i];
                footerRow.delegate = self;
                [items addObject:footerRow];
            } else if (arr[i].singleType == 1) {
                ZLTableViewRowModel *footerRow = [ZLTableViewRowModel new];
                footerRow.identifier = @"BLOrderFooterCell";
                footerRow.cellHeight = 40.0;
                footerRow.data = arr[i];
                footerRow.delegate = self;
                [items addObject:footerRow];
            }
            sectionModel.items = items.copy;
            [self.datas addObject:sectionModel];
            [self.manager reloadData];
        }
    } else if ([manager isEqual:self.deleteOrderAPI] || [manager isEqual:self.cancelOrderAPI]) {
        self.pageNum = 1;
        [self.getOrderListAPI loadData];
    } else if ([manager isEqual:self.returnPayAPI] && code == 200) {
        [self bl_showBackMoneySuccessAlertView];
    }
}

- (void)bl_showBackMoneySuccessAlertView {
    BLTextAlertViewController *viewController =
    [[BLTextAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                             content:@"退款申请已提交"
                                             buttons:@[@{BLAlertControllerButtonTitleKey: @"确定",
                                                         BLAlertControllerButtonTextColorKey: [UIColor whiteColor],
                                                         BLAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                                                         BLAlertControllerButtonBorderColorKey: @1,
                                                         BLAlertControllerButtonNormalBackgroundColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                                                         BLAlertControllerButtonRoundedCornersKey:@14.5
                                             },
                                                 @{BLAlertControllerButtonTitleKey: @"取消",
                                                         BLAlertControllerButtonTextColorKey: [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                                                         BLAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                                                         BLAlertControllerButtonBorderWidthKey: @1,
                                                         BLAlertControllerButtonNormalBackgroundColorKey:[UIColor whiteColor],
                                                         BLAlertControllerButtonRoundedCornersKey:@14.5
                                             }
                                                       ] tapBlock:^(BLTextAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
        
        }];
    [self.superViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    if ([manager isEqual:self.getOrderListAPI]) {
        return @{@"status": self.status,
                 @"pageNum": @(self.pageNum),
                 @"pageSize": @20
                 };
    } else if ([manager isEqual:self.cancelOrderAPI]) {
        return @{@"id": self.currentModel.Id,
                 @"singleType": @(self.currentModel.singleType)
        };
    } else if ([manager isEqual:self.deleteOrderAPI]) {
        return @{@"id": self.currentModel.Id,
                 @"singleType": @(self.currentModel.singleType)};
    } else if ([manager isEqual:self.returnPayAPI]) {
        return @{@"id": self.currentModel.Id,
                 @"singleType": @(self.currentModel.singleType)};
    }
    return nil;
}


- (void)bl_backMoney:(BLOrderModel *)model {
    self.currentModel = model;
    [self.returnPayAPI loadData];
}

- (void)bl_delete:(BLOrderModel *)model {
    self.currentModel = model;
    [self.deleteOrderAPI loadData];
}

- (void)bl_viewDetail:(BLOrderModel *)model {
    self.currentModel = model;
    BLOrderDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLOrderDetailViewController"];
    viewController.goodsId = model.Id;
    viewController.singleType = model.singleType;
    [self.superViewController.navigationController pushViewController:viewController animated:YES];
}

- (void)bl_toPay:(BLOrderModel *)model {
    self.currentModel = model;
    BLRePayViewController *controller = [BLRePayViewController new];
    controller.orderId = model.Id;
    controller.singleType = model.singleType;
    [self.superViewController.navigationController pushViewController:controller animated:YES];
}

- (void)bl_cancel:(BLOrderModel *)model {
    self.currentModel = model;
    [self.cancelOrderAPI loadData];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (BLGetOrderListAPI *)getOrderListAPI {
    if (!_getOrderListAPI) {
        _getOrderListAPI = [BLGetOrderListAPI new];
        _getOrderListAPI.mj_delegate = self;
        _getOrderListAPI.paramSource = self;
    }
    return _getOrderListAPI;
}

- (BLCancelOrderAPI *)cancelOrderAPI {
    if (!_cancelOrderAPI) {
        _cancelOrderAPI = [BLCancelOrderAPI new];
        _cancelOrderAPI.mj_delegate = self;
        _cancelOrderAPI.paramSource = self;
    }
    return _cancelOrderAPI;
}

- (BLDeleteOrderAPI *)deleteOrderAPI {
    if (!_deleteOrderAPI) {
        _deleteOrderAPI = [BLDeleteOrderAPI new];
        _deleteOrderAPI.mj_delegate = self;
        _deleteOrderAPI.paramSource = self;
    }
    return _deleteOrderAPI;
}

- (BLReturnPayAPI *)returnPayAPI {
    if (!_returnPayAPI) {
        _returnPayAPI = [BLReturnPayAPI new];
        _returnPayAPI.mj_delegate = self;
        _returnPayAPI.paramSource = self;
    }
    return _returnPayAPI;
}


@end
