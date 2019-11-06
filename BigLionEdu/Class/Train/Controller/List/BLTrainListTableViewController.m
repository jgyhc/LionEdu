//
//  BLTrainListTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainListTableViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLQuestionEveryDayViewController.h"
#import "BLGetCurriculumListAPI.h"
#import "BLCurriculumModel.h"
#import <YYModel.h>
#import <MJPlaceholder.h>
#import <MJRefresh.h>

@interface BLTrainListTableViewController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) BLGetCurriculumListAPI * getCurriculumListAPI;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray * datas;
@end

@implementation BLTrainListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.page = 1;
        [wself.getCurriculumListAPI loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        wself.page ++;
        [wself.getCurriculumListAPI loadData];
    }];
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"暂无数据",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
    [self.getCurriculumListAPI loadData];
    
}

- (UIView *)listView {
    return self.view;
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        NSMutableArray *items = [NSMutableArray array];
        sectionModel.items = items;
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLTrainListTableViewCell";
            rowModel.cellHeight = 111;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLTrainListTableViewCell";
            rowModel.cellHeight = 111;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLTrainListTableViewCell";
            rowModel.cellHeight = 111;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLTrainListTableViewCell";
            rowModel.cellHeight = 111;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLTrainListTableViewCell";
            rowModel.cellHeight = 111;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLTrainListTableViewCell";
            rowModel.cellHeight = 111;
            rowModel;
        })];
        sectionModel;
    })];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    BLQuestionEveryDayViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLQuestionEveryDayViewController"];
    
    [self.superViewController.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getCurriculumListAPI isEqual:manager]) {
        return @{
                 @"functionTypeId":@(_functionTypeId),
                 @"modelId":@(_modelId),
                 @"type":@(_type),
                 @"pageNum":@(_page),
                 @"pageSize":@20
                 };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if ([self.getCurriculumListAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSDictionary *json = [data objectForKey:@"data"];
            NSArray<BLCurriculumModel *> *models = [NSArray yy_modelArrayWithClass:[BLCurriculumModel class] json:[json objectForKey:@"list"]];

            if (self.page == 1) {
                [self.datas removeAllObjects];
            }
            NSMutableArray *items = [NSMutableArray array];
            [models enumerateObjectsUsingBlock:^(BLCurriculumModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [items addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLTrainListTableViewCell";
                    rowModel.cellHeight = 111;
                    rowModel.data = obj;
                    rowModel;
                })];
            }];
            
            [self.datas addObjectsFromArray:items];
             if (models.count < 20) {
                 [self.tableView.mj_footer endRefreshingWithNoMoreData];
             }
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}


- (BLGetCurriculumListAPI *)getCurriculumListAPI {
    if (!_getCurriculumListAPI) {
        _getCurriculumListAPI = [[BLGetCurriculumListAPI alloc] init];
        _getCurriculumListAPI.mj_delegate = self;
        _getCurriculumListAPI.paramSource = self;
    }
    return _getCurriculumListAPI;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

@end
