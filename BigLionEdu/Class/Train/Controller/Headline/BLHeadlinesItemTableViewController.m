//
//  BLHeadlinesItemTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLHeadlinesItemTableViewController.h"
#import "ZLTableViewDelegateManager.h"
#import <CTMediator.h>
#import "BLHeadlineDetailViewController.h"
#import "BLGetAppNewsListAPI.h"
#import <YYModel.h>
#import <MJRefresh.h>
#import <MJPlaceholder.h>

@interface BLHeadlinesItemTableViewController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;

@property (nonatomic, strong) ZLTableViewSectionModel *sectionModel;

@property (nonatomic, strong) BLGetAppNewsListAPI *getAppNewsListAPI;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation BLHeadlinesItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.pageNum = 1;
        [wself.getAppNewsListAPI loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        wself.pageNum ++;
        [wself.getAppNewsListAPI loadData];
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

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getAppNewsListAPI isEqual:manager]) {
        return @{@"typeId": @(_typeId),
                 @"pageNum": @(_pageNum),
                 @"pageSize": @20
                };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getAppNewsListAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            BLNewsListModel *model = [BLNewsListModel yy_modelWithJSON:[data objectForKey:@"data"]];
            NSMutableArray *rows = [NSMutableArray array];
            [model.list enumerateObjectsUsingBlock:^(BLNewsDTOListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [rows addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLHotLinesTableViewCell";
                    rowModel.cellHeight = -1;
                    rowModel.data = obj;
                    rowModel;
                })];
            }];
            if (rows.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.pageNum == 1) {
                [self.list removeAllObjects];
            }
            [self.list addObjectsFromArray:rows];
            [self.manager reloadData];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[self.sectionModel];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    BLNewsDTOListModel *data = model.data;
//    UIViewController *viewController = [[CTMediator sharedInstance] performTarget:@"web" action:@"webViewController" params:@{@"htmlString": data.content?data.content:@""} shouldCacheTarget:YES];
    BLHeadlineDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLHeadlineDetailViewController"];
    viewController.newId = data.Id;
    
    [self.superViewController.navigationController pushViewController:viewController animated:YES];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (ZLTableViewSectionModel *)sectionModel {
    if (!_sectionModel) {
        _sectionModel = [ZLTableViewSectionModel new];
        _sectionModel.items = self.list;
    }
    return _sectionModel;
}

- (BLGetAppNewsListAPI *)getAppNewsListAPI {
    if (!_getAppNewsListAPI) {
        _getAppNewsListAPI = [[BLGetAppNewsListAPI alloc] init];
        _getAppNewsListAPI.mj_delegate = self;
        _getAppNewsListAPI.paramSource = self;
    }
    return _getAppNewsListAPI;
}

- (NSMutableArray *)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

@end
