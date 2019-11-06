//
//  BLQuestionBankMockViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLQuestionBankMockViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLGetMockExamListAPI.h"
#import <MJRefresh.h>
#import <MJPlaceholder.h>
#import "BLMockItemModel.h"
#import <YYModel.h>
#import "BLMockDetailViewController.h"

@interface BLQuestionBankMockViewController ()<ZLTableViewDelegateManagerDelegate, CTAPIManagerParamSource, MJAPIBaseManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager * manager;

@property (nonatomic, strong) ZLTableViewSectionModel * sectionModel;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray * datas;

@property (nonatomic, strong) BLGetMockExamListAPI * getMockExamListAPI;
@end

@implementation BLQuestionBankMockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.page = 1;
        [wself.getMockExamListAPI loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        wself.page ++;
        [wself.getMockExamListAPI loadData];
    }];
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"暂无数据",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
    [self.getMockExamListAPI loadData];
}

- (UIView *)listView {
    return self.view;
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getMockExamListAPI isEqual:manager]) {
        return @{
                @"functionTypeId":@(_functionTypeId),
                @"modelId": @(_modelId),
                @"pageNum":@(_page),
                @"pageSize": @20
                };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getMockExamListAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.page == 1) {
                [self.datas removeAllObjects];
            }
            NSArray<BLMockItemModel *> *list = [NSArray yy_modelArrayWithClass:[BLMockItemModel class] json:[data objectForKey:@"data"]];
            NSMutableArray *rows = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(BLMockItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [rows addObject:({
                    ZLTableViewRowModel *model = [ZLTableViewRowModel new];
                    model.identifier = @"BLMockItemTableViewCell";
                    model.data = obj;
                    model.cellHeight = 71;
                    model;
                })];
            }];
            [self.datas addObjectsFromArray:rows];
             if (rows.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.manager reloadData];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[self.sectionModel];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    BLMockDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMockDetailViewController"];
    viewController.model = model.data;
    viewController.modelId = _modelId;
    viewController.functionTypeId = _functionTypeId;
    [self.superViewController.navigationController pushViewController:viewController animated:YES];
}

- (ZLTableViewSectionModel *)sectionModel {
    if (!_sectionModel) {
        _sectionModel = [ZLTableViewSectionModel new];
        _sectionModel.items = self.datas;
    }
    return _sectionModel;
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.tableView = self.tableView;
        _manager.delegate = self;
    }
    return _manager;
}

- (BLGetMockExamListAPI *)getMockExamListAPI {
    if (!_getMockExamListAPI) {
        _getMockExamListAPI = [[BLGetMockExamListAPI alloc] init];
        _getMockExamListAPI.mj_delegate = self;
        _getMockExamListAPI.paramSource = self;
    }
    return _getMockExamListAPI;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
             
             
@end
