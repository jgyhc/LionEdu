//
//  BLMessageListVC.m
//  BigLionEdu
//
//  Created by sunmaomao on 2019/9/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMessageListViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAPPMyMessageApi.h"
#import "ZLUserInstance.h"
#import "BLMyNewsModel.h"
#import <NSObject+YYModel.h>
#import <MJPlaceholderView/MJPlaceholderView.h>
#import <MJPlaceholderView/UITableView+MJPlaceholder.h>

@interface BLMessageListViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) BLAPPMyMessageApi *messageApi;
@property(nonatomic, strong) NSMutableArray *sectionModelItems;

@end

@implementation BLMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.messageApi loadData];
    self.sectionModelItems = [NSMutableArray new];
    [self.manager reloadData];
    self.title = self.titleStr;
}

-(void)setPlaceholderViewWith:(BOOL)isNoData{
    if (isNoData) {
        MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
        view.noDataPlacehoderParam = @{
                                       @"title": @"暂时没有什么数据",
                                       @"image":[UIImage imageNamed:@"placeholder"]
                                       };
        self.tableView.placeholderView = view;
    } else {
        MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
        view.noDataPlacehoderParam = @{
                                       @"title": @"暂时没有什么数据",
                                       @"image":[UIImage imageNamed:@"placeholder"]
                                       };
        [view placeholderStartLoading];
        self.tableView.placeholderView = view;
    }
}

#pragma mark data

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.messageApi isEqual:manager]) {
        return @{@"messageTypeId":@(self.messageTypeId)
                 };
    }
    return nil;
}

- (BLAPPMyMessageApi *)messageApi{
    if (!_messageApi) {
        _messageApi =[[BLAPPMyMessageApi alloc]init];
        _messageApi.mj_delegate =self;
        _messageApi.paramSource =self;
    }
    return _messageApi;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    if (code != 200) {
        return;
    }
    NSArray  *model = [data objectForKey:@"data"];
    if (model.count == 0) {
        [self setPlaceholderViewWith:YES];
        return;
    }
    for (NSDictionary *dic in model) {
        BLMyNewsModel *model = [BLMyNewsModel yy_modelWithJSON:dic];
        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
        rowModel.identifier = @"BLMessageListTableViewCell";
        rowModel.data = model;
        [self.sectionModelItems addObject:rowModel];
    }
    [self.manager reloadData];
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        sectionModel.items = self.sectionModelItems;
        sectionModel;
    })];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    
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
