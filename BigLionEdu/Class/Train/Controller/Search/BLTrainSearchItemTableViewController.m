//
//  BLTrainSearchItemTableViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainSearchItemTableViewController.h"
#import "ZLTableViewDelegateManager.h"
#import <MJRefresh.h>
#import <MJPlaceholder.h>
#import "BLGetSetSearchAPI.h"
#import "BLPaperModel.h"
#import <YYModel.h>
#import "BLTopicViewController.h"
#import "ZLUserInstance.h"

@interface BLTrainSearchItemTableViewController ()<ZLTableViewDelegateManagerDelegate, CTAPIManagerParamSource, MJAPIBaseManagerDelegate>
@property (nonatomic, strong) ZLTableViewDelegateManager * manager;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray * datas;

@property (nonatomic, strong) BLGetSetSearchAPI * getSetSearchAPI;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation BLTrainSearchItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.page = 1;
        [wself.getSetSearchAPI loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        wself.page ++;
        [wself.getSetSearchAPI loadData];
    }];
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"暂无数据",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
    [self.tableView.mj_header beginRefreshing];
}

- (UIView *)listView {
    return self.view;
}

#pragma mark -- ZLTableViewDelegateManagerDelegate method
- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        sectionModel.items = self.datas;
        sectionModel;
    })];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    BLPaperModel *data = model.data;
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    BLTopicViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
    viewController.setId = data.Id;
    viewController.modelId = data.modelId;
    viewController.functionTypeId = data.functionTypeId;
    viewController.topicTitle = data.title;
    viewController.duration = [data.duration integerValue];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getSetSearchAPI isEqual:manager]) {
        return @{@"modelId": @(_modelId),
                 @"functionTypeId": @(_functionTypeId),
                 @"searchTitle": _searchTitle?_searchTitle:@"",
                 @"pageNum": @(_page),
                 @"pageSize": @(20)
        };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getSetSearchAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSArray<BLPaperModel *> *list = [NSArray yy_modelArrayWithClass:[BLPaperModel class] json:[data objectForKey:@"data"]];
            NSMutableArray *items = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(BLPaperModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [items addObject:({
                    ZLTableViewRowModel *model = [ZLTableViewRowModel new];
                    model.identifier = @"BLTrainSearchItemTableViewCell";
                    model.cellHeight = 71;
                    model.data = obj;
                    model;
                })];
            }];
            
            if (_page == 1) {
                [self.datas removeAllObjects];;
            }
            if (list.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.datas addObjectsFromArray:items];
            [self.manager reloadData];
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (BLGetSetSearchAPI *)getSetSearchAPI {
    if (!_getSetSearchAPI) {
        _getSetSearchAPI = [[BLGetSetSearchAPI alloc] init];
        _getSetSearchAPI.paramSource = self;
        _getSetSearchAPI.mj_delegate = self;
    }
    return _getSetSearchAPI;
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

@end
