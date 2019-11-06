//
//  BLMyClassTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyClassTableViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAPPMyselfClassListAPI.h"
#import "BLMyClassListModel.h"
#import <YYModel/NSObject+YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import <MJPlaceholderView/MJPlaceholderView.h>
#import <MJPlaceholderView/UITableView+MJPlaceholder.h>

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface BLMyClassTableViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic ,strong) BLAPPMyselfClassListAPI *myClassListAPI;
@property(nonatomic, strong) NSMutableArray <ZLTableViewRowModel*>*sectionModelItems;
@property(assign)NSInteger pageNum;
@end

@implementation BLMyClassTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:randomColor];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataWithIsLoadMore:NO];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self getDataWithIsLoadMore:YES];
    }];
    
    [self setPlaceholderViewWith:NO];
    [self.myClassListAPI loadData];
}

#pragma mark views
- (UIView *)listView {
    return self.view;
}


-(void)setPlaceholderViewWith:(BOOL)isNoData{
    if (isNoData) {
        MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
        view.noDataPlacehoderParam = @{
                                       @"title": @"暂无课程",
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
- (void)getDataWithIsLoadMore:(BOOL)isLoadMore{
    if ( isLoadMore) {
    }else{
        _pageNum = 1;
    }
    [self.myClassListAPI loadData];
}

-(BLAPPMyselfClassListAPI *)myClassListAPI{
    if (_myClassListAPI == nil) {
        _myClassListAPI = [BLAPPMyselfClassListAPI new];
        _myClassListAPI.mj_delegate = self;
        _myClassListAPI.paramSource = self;
    }
    return  _myClassListAPI;
}

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.myClassListAPI isEqual:manager]) {
        NSNumber *type = @1;
        switch (self.classType) {
            case live:
                type = @1;
                break;
            case video:
                type = @2;
                break;
            case interview:
                type = @3;
                break;
            default:
                break;
        }
        return @{@"memberId": @(2019001101),
                 @"type":type,
                 @"pageNum":@(_pageNum),
                 @"pageSize":@(100)
                 };
    }
    return nil;
}

-(void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    if (code != 200) {
        return;
    }
    NSArray *models = [data objectForKey:@"data"];
    if (models.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
    
    NSString *cellid = @"BLMyClassLiveTableViewCell";
    switch (self.classType) {
        case live:
            cellid = @"BLMyClassLiveTableViewCell";
            break;
        case video: interview:
            cellid = @"BLMyClassVideoTableViewCell";
            break;
        default:
            break;
    }
    for (NSDictionary *dic in models) {
        BLMyClassListModel *model = [BLMyClassListModel yy_modelWithJSON:dic];
        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
        rowModel.identifier = cellid;
        rowModel.cellHeight = 126;
        rowModel.data = model;
        [self.sectionModelItems addObject:rowModel];
    }
    if (self.sectionModelItems.count == 0) {
        [self setPlaceholderViewWith:YES];
    }
     [self.manager reloadData];
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

#pragma mark table
- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        sectionModel.items = self.sectionModelItems;
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

@end
