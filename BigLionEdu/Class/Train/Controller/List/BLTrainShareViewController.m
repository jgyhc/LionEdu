//
//  BLTrainShareViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainShareViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLGetCurriculumListAPI.h"
#import <MJRefresh.h>
#import <MJPlaceholder.h>
#import "BLCurriculumModel.h"
#import <YYModel.h>
#import "BLTrainShareDetailController.h"
#import "BLTrainShareBuyAlertView.h"
#import "BLRePayViewController.h"
#import "NTCatergory.h"

@interface BLTrainShareViewController ()<ZLTableViewDelegateManagerDelegate, CTAPIManagerParamSource, MJAPIBaseManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) BLGetCurriculumListAPI * getCurriculumListAPI;
@property (nonatomic, strong) NSMutableArray * datas;

@end

@implementation BLTrainShareViewController

//狮享课
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.manager reloadData];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
                                   @"title": @"暂时没有什么数据",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
    self.view.backgroundColor = self.tableView.backgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    BLCurriculumModel *obj = model.data;
    
//    BLTrainShareDetailController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainShareDetailController"];
//    viewController.Id = obj.Id;
//    [self.superViewController.navigationController pushViewController:viewController animated:YES];
//
    if (obj.isPurchase == 1 || obj.price.floatValue <= 0.0) {
        BLTrainShareDetailController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainShareDetailController"];
        viewController.Id = obj.Id;
        [self.superViewController.navigationController pushViewController:viewController animated:YES];
    } else {
        BLTrainShareBuyAlertView *view = [BLTrainShareBuyAlertView new];
        view.priceLab.text = [NSString stringWithFormat:@"￥%.2lf", obj.price.floatValue];
        __weak typeof(self) wself = self;
        [view setSureHandler:^{
            BLRePayViewController *controller = [BLRePayViewController new];
            controller.functionTypeId = wself.functionTypeId;
            controller.price = [NSString stringWithFormat:@"￥%.2lf", obj.price.floatValue];
            [wself.superViewController.navigationController pushViewController:controller animated:YES];
        }];
        [view show];
    }
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
                    rowModel.identifier = @"BLTrainListShareTableViewCell";
                    rowModel.cellHeight = 126;
                    rowModel.data = obj;
                    rowModel;
                })];
            }];
            
            [self.datas addObjectsFromArray:items];
            if (models.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.manager reloadData];
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
