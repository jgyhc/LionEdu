//
//  BLMyClassTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyCollectTableViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAPPMyselfGetAppMyQuestionErrorInfoAPI.h"

#import "BLMyMistakeModel.h"
#import <YYModel/NSObject+YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import <MJPlaceholder.h>
#import "BLTopicViewController.h"
#import "UIViewController+ORAdd.h"

@interface BLMyCollectTableViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic ,strong)BLAPPMyselfGetAppMyQuestionErrorInfoAPI *errorInfoAPI;
@property(assign)NSInteger pageNum;

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) NSArray <BLMyMistakeModel *>*models;

@end

@implementation BLMyCollectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.manager reloadData];
    [self setPlaceholderViewWith:NO];
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
}

#pragma mark views
- (UIView *)listView {
    return self.view;
}


-(void)setPlaceholderViewWith:(BOOL)isNoData{
    if (isNoData) {
        MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
        view.noDataPlacehoderParam = @{
                                       @"title": @"暂无数据",
                                       @"image":[UIImage imageNamed:@"placeholder"]
                                       };
        self.tableView.placeholderView = view;
    }else{
        MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
        view.noDataPlacehoderParam = @{
                                       @"title": @"获取数据中",
                                       @"image":[UIImage imageNamed:@"placeholder"]
                                       };
        [view placeholderStartLoading];
        self.tableView.placeholderView = view;
    }
}


#pragma mark data
-(void)getDataWithIsLoadMore:(BOOL)isLoadMore{
    if ( isLoadMore) {
    }else{
        _pageNum = 1;
    }
    [self.errorInfoAPI loadData];
}

-(BLAPPMyselfGetAppMyQuestionErrorInfoAPI *)errorInfoAPI{
    if (_errorInfoAPI == nil) {
        _errorInfoAPI = [BLAPPMyselfGetAppMyQuestionErrorInfoAPI new];
        _errorInfoAPI.mj_delegate = self;
        _errorInfoAPI.paramSource = self;
    }
    return  _errorInfoAPI;
}

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.errorInfoAPI isEqual:manager]) {

        return @{@"modelId" : @(self.modelID),@"type" : @(2)};
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
    NSArray *models = [NSArray yy_modelArrayWithClass:[BLMyMistakeModel class] json:modelDic];
    _models = models;
    [self _or_reloadRowData];
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

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLMyCollectGroupTableViewCell"]) {
        BLMyMistakeModel *data = model.data;
        data.isPull = !data.isPull;
        [self _or_reloadRowData];
        return;
    }
    if ([model.identifier isEqualToString:@"BLMyCollectItemTableViewCell"]) {
        BLMyMistakeQuestionModel *data = model.data;
        BLTopicViewController *viewController =  [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
        viewController.modelId = data.modelId;
        viewController.functionTypeId = data.functionTypeId;
        viewController.analysisParams = [data yy_modelToJSONObject];
        [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
        return;
    }
}

#pragma mark -- private

- (void)_or_reloadRowData {
    
    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:({
//        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
//        rowModel.identifier = @"BLMistakesTopTableViewCell";
//        rowModel.cellHeight = 30;
//        rowModel;
//    })];
    
    [_models enumerateObjectsUsingBlock:^(BLMyMistakeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self _or_addRowModelWith:obj array:array isMain:YES];
    }];
    self.datasource = array;
    [self.manager reloadData];
}

- (void)_or_addRowModelWith:(BLMyMistakeModel *)model array:(NSMutableArray *)array isMain:(BOOL)isMain {
    
    if (model.questionNum == 0) {
        return;
    }
    
    [array addObject:({
        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
        rowModel.identifier = @"BLMyCollectGroupTableViewCell";
        rowModel.cellHeight = 56;
        rowModel.data = model;
        rowModel;
    })];
    
    if (model.isPull) {
        [model.questionList enumerateObjectsUsingBlock:^(BLMyMistakeQuestionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLMyCollectItemTableViewCell";
                rowModel.cellHeight = -1;
                rowModel.data = obj;
                rowModel;
            })];
        }];
        
        [model.functionTypeDTOList enumerateObjectsUsingBlock:^(BLMyMistakeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self _or_addRowModelWith:obj array:array isMain:model.isPull];
        }];
    }
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
