//
//  BLQuestionEveryDayViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/5.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLQuestionEveryDayViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLMultipleChoiceTopicViewController.h"
#import <objc/runtime.h>
#import "BLGetDailyTipOrQuestionAPI.h"
#import "ZLUserInstance.h"
#import "BLResponseDailyQuestionModel.h"
#import <YYModel.h>
#import <MJRefresh.h>
#import "BLTopicViewController.h"
#import "BLTopicModel.h"

@interface BLQuestionEveryDayViewController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) BLGetDailyTipOrQuestionAPI *getDailyTipOrQuestionAPI;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) ZLTableViewSectionModel * sectionModel;

@property (nonatomic, strong) ZLTableViewRowModel * headerRowModel;

@property (nonatomic, strong) BLResponseDailyQuestionModel *model;
@end

@implementation BLQuestionEveryDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _pageNum = 1;
    
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.pageNum = 1;
        [wself.getDailyTipOrQuestionAPI loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        wself.pageNum ++;
        [wself.getDailyTipOrQuestionAPI loadData];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}


- (IBAction)backEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[self.sectionModel];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLEverydayItemTableViewCell"]) {
        BLTopicModel *data = model.data;
        if (![ZLUserInstance sharedInstance].isLogin) {
            [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
            return;
        }
        BLTopicViewController *viewController =  [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
        viewController.modelId = _modelId;
        viewController.functionTypeId = _functionTypeId;
        viewController.topicModel = data;
        viewController.topicTitle = data.title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getDailyTipOrQuestionAPI isEqual:manager]) {
        return  @{
            @"functionTypeId": @(_functionTypeId),
            @"memberId": @([ZLUserInstance sharedInstance].Id),
            @"modelId": @(_modelId),
            @"pageNum": @(_pageNum),
            @"pageSize": @20
        };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if ([self.getDailyTipOrQuestionAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            if (self.pageNum == 1) {
                [self.datas removeAllObjects];
            }
            BLResponseDailyQuestionModel *model = [BLResponseDailyQuestionModel yy_modelWithJSON:[data objectForKey:@"data"]];
            _model = model;
             if (model.question.optionList.count < 20) {
                 [self.tableView.mj_footer endRefreshingWithNoMoreData];
             }
            self.headerRowModel.data = model.dailyTip;
            if (model.question) {
                NSMutableArray *datas = [NSMutableArray array];
                [datas addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLEverydayItemTableViewCell";
                    rowModel.cellHeight = 105;
                    rowModel.data = model.question;
                    rowModel;
                })];
                [self.datas addObjectsFromArray:datas];
            }
            NSMutableArray *items = [NSMutableArray array];
            [items addObject:self.headerRowModel];
            [items addObjectsFromArray:self.datas];
            self.sectionModel.items = items;
            [self.manager reloadData];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (BLGetDailyTipOrQuestionAPI *)getDailyTipOrQuestionAPI {
    if (!_getDailyTipOrQuestionAPI) {
        _getDailyTipOrQuestionAPI = [[BLGetDailyTipOrQuestionAPI alloc] init];
        _getDailyTipOrQuestionAPI.mj_delegate = self;
        _getDailyTipOrQuestionAPI.paramSource = self;
    }
    return _getDailyTipOrQuestionAPI;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (ZLTableViewSectionModel *)sectionModel {
    if (!_sectionModel) {
        _sectionModel = ({
            ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
//            NSMutableArray *items = [NSMutableArray array];
//            sectionModel.items = items;
//            [items addObject:self.headerRowModel];
            sectionModel;
        });
    }
    return _sectionModel;
}

- (ZLTableViewRowModel *)headerRowModel {
    if (!_headerRowModel) {
        _headerRowModel = [ZLTableViewRowModel new];
        _headerRowModel.identifier = @"BLEveryDayHeaderTableViewCell";
        _headerRowModel.cellHeight = 183;
    }
    return _headerRowModel;
}

@end
