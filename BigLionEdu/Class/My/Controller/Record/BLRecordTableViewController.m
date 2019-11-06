//
//  BLMyClassTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLRecordTableViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAPPMyRecordApi.h"
#import "UIViewController+ORAdd.h"
#import "BLMyRecordModel.h"
#import <YYModel/NSObject+YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import <MJPlaceholderView/MJPlaceholderView.h>
#import <MJPlaceholderView/UITableView+MJPlaceholder.h>
#import <LCProgressHUD.h>
#import "BLTopicViewController.h"
#import "UIViewController+ORAdd.h"
#import "ZLFactory.h"
#import "NTCatergory.h"
#import "BLAnswerReportViewController.h"

@interface BLRecordTableViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic ,strong) BLAPPMyRecordInfoApi *recordInfoAPI;

@property(assign)NSInteger pageNum;

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) NSArray <BLMyRecordInfoModel *>*models;

@end

@implementation BLRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.manager reloadData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getDataWithIsLoadMore:NO];
        }];
        
    //    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
    //        [self getDataWithIsLoadMore:YES];
    //    }];
    
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"暂无数据",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
    [self getDataWithIsLoadMore:NO];
    self.tableView.tableFooterView = [UIView new];
    
    UILabel *label = [ZLFactory labelWithFont:[UIFont systemFontOfSize:12] textColor:NT_HEX(49495E)];
    label.text = @"       大狮解小吼一声：答题记录保留1个月。";
    label.frame = CGRectMake(0, 0, 0, 35);
    self.tableView.tableHeaderView = label;
}

- (UIView *)listView {
    return self.view;
}

#pragma mark data
-(void)getDataWithIsLoadMore:(BOOL)isLoadMore{
    if ( isLoadMore) {
    }else{
        _pageNum = 1;
    }
    [self.recordInfoAPI loadData];
}


- (id _Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.recordInfoAPI isEqual:manager]) {
        return @{@"modelId" : @(self.modelID)};
    }
    
    return nil;
}

-(void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    if (code != 200) {
        return;
    }
    
    NSDictionary *modelDic = [data objectForKey:@"data"];
    
    NSArray *models = [NSArray yy_modelArrayWithClass:[BLMyRecordInfoModel class] json:modelDic];
    _models = models;
    [self _or_reloadRowData];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLRecordHeaderTableViewCell"]) {
        BLMyRecordInfoModel *data = model.data;
        data.isPull = !data.isPull;
        [self _or_reloadRowData];
        return;
    }
    if ([model.identifier isEqualToString:@"BLRecordItemTableViewCell"]) {
        BLMyRecordDTOListModel *data = model.data;
        if (data.status == 1) {//已完成
            BLAnswerReportViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLAnswerReportViewController"];
            viewController.setId = data.modelid;
            viewController.modelId = data.modelId;
            viewController.functionTypeId = data.functionTypeId;
            viewController.setRecId = data.setRecId;
//                viewController.paperModel = wself.paperModel;
//                viewController.topicList = wself.topicList;
            [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
        }else {
            BLTopicViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
            viewController.setId = data.modelid;
            viewController.modelId = data.modelId;
            viewController.topicTitle = data.title;
            viewController.functionTypeId = data.functionTypeId;
            viewController.duration = [data.duration integerValue];;
            [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
        }
        return;
    }
}


- (void)_or_reloadRowData {
    
    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:({
//        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
//        rowModel.identifier = @"BLRecordTopTableViewCell";
//        rowModel.cellHeight = 30;
//        rowModel;
//    })];
    
    [_models enumerateObjectsUsingBlock:^(BLMyRecordInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self _or_addRowModelWith:obj array:array isMain:YES];
    }];
    self.datasource = array.count > 1 ? array : nil;
    [self.manager reloadData];
}

- (void)_or_addRowModelWith:(BLMyRecordInfoModel *)model array:(NSMutableArray *)array isMain:(BOOL)isMain {
    
    if (model.questionNum == 0) {
        return;
    }
    
    [array addObject:({
        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
        rowModel.identifier = @"BLRecordHeaderTableViewCell";
        rowModel.cellHeight = (model.isPull || isMain) ? 56 : 0;
        rowModel.data = model;
        rowModel.delegate = self;
        rowModel;
    })];
    [model.setRecordDTOList enumerateObjectsUsingBlock:^(BLMyRecordDTOListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLRecordItemTableViewCell";
            rowModel.cellHeight = model.isPull ? 68 : 0;
            rowModel.data = obj;
            rowModel.delegate = self;
            rowModel;
        })];
    }];
    
    [model.functionTypeDTOList enumerateObjectsUsingBlock:^(BLMyRecordInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self _or_addRowModelWith:obj array:array isMain:model.isPull];
    }];
    
}



- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        sectionModel.items = self.datasource;
        sectionModel;
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

- (BLAPPMyRecordInfoApi *)recordInfoAPI {
    if (!_recordInfoAPI) {
        _recordInfoAPI = [BLAPPMyRecordInfoApi new];
        _recordInfoAPI.mj_delegate = self;
        _recordInfoAPI.paramSource = self;
    }
    return _recordInfoAPI;
}

@end
