//
//  BLMealFailureTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/13.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMealFailureTableViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAPPMySelfMealApi.h"
#import <NSObject+YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import <MJPlaceholderView/MJPlaceholderView.h>
#import <MJPlaceholderView/UITableView+MJPlaceholder.h>
#import "BLMyMealModel.h"
#import "ZLUserInstance.h"

@interface BLMealFailureTableViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic ,strong) BLAPPMySelfMyInvalidMealApi *mySelfMyInvalidMealApi;
@property(nonatomic, strong) NSMutableArray *sectionModelItems;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation BLMealFailureTableViewController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.manager reloadData];
    self.sectionModelItems = [NSMutableArray new];
    
    _pageNum = 1;
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.pageNum = 1;
        [wself.mySelfMyInvalidMealApi loadData];
    }];
//    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
//        wself.pageNum ++;
//        [wself.mySelfMyInvalidMealApi loadData];
//    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"暂无优惠券",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
}

#pragma mark data
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.mySelfMyInvalidMealApi isEqual:manager]) {
        return @{@"memberId":@([ZLUserInstance sharedInstance].Id)
                 };
    }
    return nil;
}

- (BLAPPMySelfMyInvalidMealApi *)mySelfMyInvalidMealApi{
    if (!_mySelfMyInvalidMealApi) {
        _mySelfMyInvalidMealApi =[[BLAPPMySelfMyInvalidMealApi alloc]init];
        _mySelfMyInvalidMealApi.mj_delegate = self;
        _mySelfMyInvalidMealApi.paramSource = self;
    }
    return _mySelfMyInvalidMealApi;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    
    if (code != 200) {
        return;
    }
    
    if (self.pageNum == 1) {
        [self.sectionModelItems removeAllObjects];
    }

    id model = [data objectForKey:@"data"];
    
    
    for (NSDictionary *dic in model) {
        BLMyMyMealModel *model = [BLMyMyMealModel yy_modelWithJSON:dic];
        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
        rowModel.identifier = @"BLMealFailureTableViewCell";
        rowModel.cellHeight = 156;
        rowModel.data = model;
        [self.sectionModelItems addObject:rowModel];
    }
    [self.manager reloadData];
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark view

#pragma mark table
- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionMdoel = [ZLTableViewSectionModel new];
        sectionMdoel.items = self.sectionModelItems;
//  @[
//                               ({
//                                   ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
//                                   rowModel.identifier = @"BLMealFailureTableViewCell";
//                                   rowModel.cellHeight = 156;
//                                   rowModel;
//                               }),({
//                                   ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
//                                   rowModel.identifier = @"BLMealFailureTableViewCell";
//                                   rowModel.cellHeight = 156;
//                                   rowModel;
//                               }),({
//                                   ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
//                                   rowModel.identifier = @"BLMealFailureTableViewCell";
//                                   rowModel.cellHeight = 156;
//                                   rowModel;
//                               }),({
//                                   ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
//                                   rowModel.identifier = @"BLMealFailureTableViewCell";
//                                   rowModel.cellHeight = 156;
//                                   rowModel;
//                               }),({
//                                   ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
//                                   rowModel.identifier = @"BLMealFailureTableViewCell";
//                                   rowModel.cellHeight = 156;
//                                   rowModel;
//                               })];
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

@end
