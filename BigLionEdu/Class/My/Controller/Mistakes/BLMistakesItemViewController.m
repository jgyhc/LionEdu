//
//  BLMistakesItemViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMistakesItemViewController.h"
#import "BLTopicViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAPPMyselfGetAppMyQuestionErrorInfoAPI.h"
#import "BLMyMistakeModel.h"
#import "UIViewController+ORAdd.h"
#import <YYModel/NSObject+YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import <MJPlaceholderView/MJPlaceholderView.h>
#import <MJPlaceholderView/UITableView+MJPlaceholder.h>
#import <LCProgressHUD.h>
#import "ZLFactory.h"
#import "NTCatergory.h"

@interface BLMistakesItemViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic ,strong)BLAPPMyselfGetAppMyQuestionErrorInfoAPI *errorInfoAPI;
@property (nonatomic ,strong)BLAPPMyselfDeleteMyQuestionErrorInfoAPI *deleteAPI;

@property(assign)NSInteger pageNum;

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) NSArray <BLMyMistakeModel *>*models;

@property (nonatomic, strong) NSArray *deleteDatas;



@end

@implementation BLMistakesItemViewController

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

    UILabel *label = [ZLFactory labelWithFont:[UIFont systemFontOfSize:12] textColor:NT_HEX(49495E)];
    label.text = @"       大狮解小吼一声：错题上线300题。";
    label.frame = CGRectMake(0, 0, 0, 35);
    self.tableView.tableHeaderView = label;
}

- (IBAction)action_allSelect:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    [_models enumerateObjectsUsingBlock:^(BLMyMistakeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = sender.selected;
    }];
    
    [self _or_reloadSeletctInfo];
    [self.manager reloadData];
}

- (IBAction)sureEvent:(UIButton *)sender {
    
    if (self.deleteDatas.count == 0) {
        [LCProgressHUD show:@"未选择错题"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self or_showAlert:@"温馨提示" message:@"确定删除？" okAction:^{
        [weakSelf.deleteAPI loadData];
    }];
    
}

#pragma mark views
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

- (UIView *)listView {
    return self.view;
}

- (void)or_celldidChangeSelected {
    
    [self _or_reloadSeletctInfo];
    
    [self.manager reloadData];
    
}

#pragma mark data
-(void)getDataWithIsLoadMore:(BOOL)isLoadMore{
    if ( isLoadMore) {
    }else{
        _pageNum = 1;
    }
    [self.errorInfoAPI loadData];
}


- (id _Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.errorInfoAPI isEqual:manager]) {
//        return @{@"memberId": @(2019001101),
//                 @"pageNum":@(_pageNum),
//                 @"pageSize":@(100)
//                 };
        return @{@"modelId" : @(self.modelID),@"type" : @(1)};
    }
    if ([self.deleteAPI isEqual:manager]) {
        return @{@"memberQuestionId" : [self.deleteDatas componentsJoinedByString:@","]};
    }
//memberQuestionId
    
    return nil;
}

-(void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    if (code != 200) {
        return;
    }
    
    if ([self.deleteAPI isEqual:manager]) {
        [self.errorInfoAPI loadData];
        return;
    }
    
    NSDictionary *modelDic = [data objectForKey:@"data"];
    
    NSArray *models = [NSArray yy_modelArrayWithClass:[BLMyMistakeModel class] json:modelDic];
    _models = models;
    [self _or_reloadRowData];
    [self _or_reloadSeletctInfo];
}


- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark table
- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        sectionModel.items = self.datasource;
        sectionModel;
    })];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLMistakesHeaderTableViewCell"]) {
        BLMyMistakeModel *data = model.data;
        data.isPull = !data.isPull;
        [self _or_reloadRowData];
//        [self _or_resetHeightWithRowModel:model row:indexPath.row];
        return;
    }
    if ([model.identifier isEqualToString:@"BLMistakesItemTableViewCell"]) {
        
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

- (void)_or_reloadSeletctInfo {
    
    NSMutableArray *array = [NSMutableArray array];
    __block NSInteger num = 0;
    __block BOOL isSelect = YES;
    [self.models enumerateObjectsUsingBlock:^(BLMyMistakeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj or_changeSelect];
        NSArray *queIDs = obj.questionIDData;
        [array addObjectsFromArray:queIDs];
        num += queIDs.count;
        if (!obj.selected) {
            isSelect = NO;
        }
    }];
    
    _deleteDatas = array.copy;
    self.selectLabel.text = [NSString stringWithFormat:@"已选择%ld条",(long)num];
    self.allSelectButton.selected = isSelect;
}

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
    self.datasource = array.count > 0 ? array : nil;
    [self.manager reloadData];
}

- (void)_or_addRowModelWith:(BLMyMistakeModel *)model array:(NSMutableArray *)array isMain:(BOOL)isMain {
    
    if (model.questionNum == 0) {
        return;
    }
    
    [array addObject:({
        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
        rowModel.identifier = @"BLMistakesHeaderTableViewCell";
        rowModel.cellHeight =  56;
        rowModel.data = model;
        rowModel.delegate = self;
        rowModel;
    })];
    if (model.isPull) {
        [model.questionList enumerateObjectsUsingBlock:^(BLMyMistakeQuestionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLMistakesItemTableViewCell";
                rowModel.cellHeight = -1;
                rowModel.data = obj;
                rowModel.delegate = self;
                rowModel;
            })];
        }];
        [model.functionTypeDTOList enumerateObjectsUsingBlock:^(BLMyMistakeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self _or_addRowModelWith:obj array:array isMain:model.isPull];
        }];
    }
}

- (void)_or_resetHeightWithRowModel:(ZLTableViewRowModel *)rowModel row:(NSInteger)row {
    if (self.datasource.count == 0) {
        return;
    }
    
    NSLog(@"time");
    
    BLMyMistakeModel *data = rowModel.data;
    rowModel.cellHeight = (data.isPull || (row == 0)) ? 56 : 0;
        
    if (data.questionList.count > 0) {
        [data.questionList enumerateObjectsUsingBlock:^(BLMyMistakeQuestionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZLTableViewRowModel *new = self.datasource[row + 1 + idx];
            new.cellHeight = data.isPull ? -1 : 0;
        }];
    }
    __block NSInteger index = 0;
    if (data.functionTypeDTOList.count > 0) {
        [data.functionTypeDTOList enumerateObjectsUsingBlock:^(BLMyMistakeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.questionNum > 0) {
                index ++;
                ZLTableViewRowModel *new = self.datasource[row + data.questionList.count + index];
                new.cellHeight = data.isPull ? 56 : 0;
            }
            
        }];
    }
    NSLog(@"time");
    [self.manager reloadData];
}


- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

-(BLAPPMyselfGetAppMyQuestionErrorInfoAPI *)errorInfoAPI{
    if (_errorInfoAPI == nil) {
        _errorInfoAPI = [BLAPPMyselfGetAppMyQuestionErrorInfoAPI new];
        _errorInfoAPI.mj_delegate = self;
        _errorInfoAPI.paramSource = self;
    }
    return  _errorInfoAPI;
}

- (BLAPPMyselfDeleteMyQuestionErrorInfoAPI *)deleteAPI {
    if (_deleteAPI == nil) {
        _deleteAPI = [BLAPPMyselfDeleteMyQuestionErrorInfoAPI new];
        _deleteAPI.mj_delegate = self;
        _deleteAPI.paramSource = self;
    }
    return  _deleteAPI;
}



@end
