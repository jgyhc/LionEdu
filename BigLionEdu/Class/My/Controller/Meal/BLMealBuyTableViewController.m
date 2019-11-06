//
//  BLMealBuyTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/13.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMealBuyTableViewController.h"
#import "BLRePayViewController.h"

#import "ZLTableViewDelegateManager.h"
#import "BLAPPMySelfMealApi.h"
#import <NSObject+YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import <MJPlaceholderView/MJPlaceholderView.h>
#import <MJPlaceholderView/UITableView+MJPlaceholder.h>
#import "BLMyMealModel.h"
#import "ZLUserInstance.h"
#import "NTCatergory.h"
#import "BLTextAlertViewController.h"
#import "BLMyInterestViewController.h"

@interface BLMealBuyTableViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic ,strong) BLAPPMySelfAllMealApi *mySelfAllMealApi;
@property (nonatomic ,strong) BLAPPCanBuyCheckApi *canBuyCheckApi;
@property(nonatomic, strong) NSMutableArray *sectionModelItems;
@property(nonatomic, strong) BLMyAllMealModel *selectModel;

@end

@implementation BLMealBuyTableViewController{
    NSInteger _pageNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"套餐办理";
    
    self.sectionModelItems = [NSMutableArray new];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.mySelfAllMealApi loadData];
    }];
    
//    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        [self getDataWithIsLoadMore:YES];
//    }];
    
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"暂无套餐",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
    
    [self.mySelfAllMealApi loadData];
    
    NT_WEAKIFY(self);
    [self nt_addNotificationForName:@"kBuyPackageSuccessNotification" block:^(NSNotification * _Nonnull notification) {
        [weak_self.mySelfAllMealApi loadData];
    }];
}



- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.mySelfAllMealApi isEqual:manager]) {
        return @{
                 };
    }
    return @{@"modelId" : @(_selectModel.modelId)};
}


- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    if (code != 200) {
        return;
    }
    
    if ([manager isEqual:self.canBuyCheckApi]) {
        
        NSInteger status = [data[@"data"] intValue];
        
        if (status == 1) {
            
            BLTextAlertViewController *viewController =
            [[BLTextAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                                     content:@"到我的兴趣选择对应的兴趣 即可解锁"
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
                if ([title isEqualToString:@"确定"]) {
                    
                    BLMyInterestViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMyInterestViewController"];
                    NT_WEAKIFY(self);
                    vc.saveBlock = ^{
                        [weak_self.tableView.mj_header beginRefreshing];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
            [self presentViewController:viewController animated:YES completion:nil];
            
            
            
        }else {
            BLRePayViewController *controller = [BLRePayViewController new];
            controller.orderId = _selectModel.modelid;
            controller.price = [NSString stringWithFormat:@"￥%.2lf", _selectModel.price];
            controller.isBuyPackage = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        
        return;
    }
    
    [self.sectionModelItems removeAllObjects];
    
    NSArray  *models = [data objectForKey:@"data"];
    for (NSDictionary *dic in models) {
        BLMyAllMealModel *model = [BLMyAllMealModel yy_modelWithJSON:dic];
        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
        rowModel.identifier = @"BLMealBuyTableViewCell";
        rowModel.cellHeight = 96;
        rowModel.data = model;
        rowModel.delegate = self;
        [self.sectionModelItems addObject:rowModel];
    }
    [self.manager reloadData];
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark table

- (void)cell:(UITableViewCell *)cell buyPackageBtnDidClickWithModel:(BLMyAllMealModel *)model {
    
    _selectModel = model;
    [self.canBuyCheckApi loadData];
    
//    BLRePayViewController *controller = [BLRePayViewController new];
//    controller.orderId = model.modelid;
//    controller.price = [NSString stringWithFormat:@"￥%.2lf", model.price];
//    controller.isBuyPackage = YES;
//    [self.navigationController pushViewController:controller animated:YES];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionMdoel = [ZLTableViewSectionModel new];
        sectionMdoel.items = self.sectionModelItems;
        sectionMdoel;
    })];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (BLAPPMySelfAllMealApi *)mySelfAllMealApi{
    if (!_mySelfAllMealApi) {
        _mySelfAllMealApi =[[BLAPPMySelfAllMealApi alloc]init];
        _mySelfAllMealApi.mj_delegate =self;
        _mySelfAllMealApi.paramSource =self;
    }
    return _mySelfAllMealApi;
}

- (BLAPPCanBuyCheckApi *)canBuyCheckApi {
    if (!_canBuyCheckApi) {
        _canBuyCheckApi =[[BLAPPCanBuyCheckApi alloc]init];
        _canBuyCheckApi.mj_delegate =self;
        _canBuyCheckApi.paramSource =self;
    }
    return _canBuyCheckApi;
}

@end
