//
//  BLFaceClassViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLFaceClassViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLGetCurriculumListAPI.h"
#import <MJRefresh.h>
#import <MJPlaceholder.h>
#import <YYModel.h>
#import "BLGetTestPaperQuestionAPI.h"
#import "BLVideoClassDetailViewController.h"
#import "NTCatergory.h"
#import "UIViewController+ORAdd.h"
#import "BLPaperModel.h"
#import <NSArray+BlocksKit.h>
#import "BLCurriculumModel.h"
#import "BLPaperBuyAlertViewController.h"
#import <LCProgressHUD.h>
#import "BLMallOrderSureViewController.h"
#import "ZLUserInstance.h"
#import "BLTopicViewController.h"
#import "UIViewController+ORAdd.h"
#import "BLGetCurriculumListAPI.h"

@interface BLFaceClassViewController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) BLGetCurriculumListAPI * getCurriculumListAPI;

@property (nonatomic, strong) NSMutableArray * datas;
//全部已经购买
@property (nonatomic, assign) BOOL isAllDidBuy;
@end

@implementation BLFaceClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.manager reloadData];
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
    [self.tableView.mj_header beginRefreshing];
}

- (UIView *)listView {
    return self.view;
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        sectionModel.items = self.datas;
        sectionModel;
    })];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getCurriculumListAPI isEqual:manager]) {
        return @{
                 @"functionTypeId":@(_functionTypeId),
                 @"modelId":@(_modelId),
                 @"type":@(5),
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
                    rowModel.identifier = @"BLFaceClassItemTableViewCell";
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
        _getCurriculumListAPI.paramSource = self;
        _getCurriculumListAPI.mj_delegate = self;
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
