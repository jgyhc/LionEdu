//
//  BLQuestionListTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLQuestionListTableViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLGetBaseTypeByIdTypeAPI.h"
#import <MJPlaceholder.h>
#import <MJRefresh.h>
#import <YYModel.h>
#import "BLQuestionEveryDayViewController.h"
#import "BLQuestionsClassificationModel.h"
#import "BLPaperViewController.h"

@interface BLQuestionListTableViewController ()<ZLTableViewDelegateManagerDelegate, CTAPIManagerParamSource, MJAPIBaseManagerDelegate>
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) BLGetBaseTypeByIdTypeAPI *getBaseTypeByIdTypeAPI;

@property (nonatomic, strong) ZLTableViewSectionModel *sectionModel;


@end

@implementation BLQuestionListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_list) {
        [self updateListWithList:[NSArray yy_modelArrayWithClass:[BLQuestionsClassificationModel class] json:_list]];
    }else {
        __weak typeof(self) wself = self;
           self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
               [wself.getBaseTypeByIdTypeAPI loadData];
           }];
           MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
           view.noDataPlacehoderParam = @{
                                          @"title": @"内容出走了，正在努力寻找中…",
                                          @"image":[UIImage imageNamed:@"placeholder"]
                                          };
           self.tableView.placeholderView = view;
           [self.tableView.mj_header beginRefreshing];
    }
   
}

- (UIView *)listView {
    return self.view;
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getBaseTypeByIdTypeAPI isEqual:manager]) {
        return @{
                 @"parentId":@(_parentId),
                 @"modelId": @(_modelId),
                 @"functionType":@1
                 };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getBaseTypeByIdTypeAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [self.tableView.mj_header endRefreshing];
            NSArray *list = [NSArray yy_modelArrayWithClass:[BLQuestionsClassificationModel class] json:[data objectForKey:@"data"]];
            [self updateListWithList:list];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
}


- (void)updateListWithList:(NSArray *)list {
    NSMutableArray *items = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLQuestionListTableViewCell";
            rowModel.cellHeight = 111;
            rowModel.data = obj;
            rowModel;
        })];
    }];
    self.sectionModel.items = items;
    [self.manager reloadData];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[self.sectionModel];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    BLQuestionsClassificationModel *data = model.data;
    if ([data.isDaily isEqualToString:@"Y"]) {
        BLQuestionEveryDayViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLQuestionEveryDayViewController"];
        viewController.modelId = _modelId;
        viewController.functionTypeId = data.Id;
        [self.superViewController.navigationController pushViewController:viewController animated:YES];
    }else {
        BLPaperViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLPaperViewController"];
        viewController.paperParams = [data yy_modelToJSONObject];
        viewController.modelId = _modelId;
        viewController.setId = data.Id;
        [self.superViewController.navigationController pushViewController:viewController animated:YES];
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


- (BLGetBaseTypeByIdTypeAPI *)getBaseTypeByIdTypeAPI {
    if (!_getBaseTypeByIdTypeAPI) {
        _getBaseTypeByIdTypeAPI = [[BLGetBaseTypeByIdTypeAPI alloc] init];
        _getBaseTypeByIdTypeAPI.mj_delegate = self;
        _getBaseTypeByIdTypeAPI.paramSource = self;
    }
    return _getBaseTypeByIdTypeAPI;
}

- (ZLTableViewSectionModel *)sectionModel {
    if (!_sectionModel) {
        _sectionModel = [ZLTableViewSectionModel new];
    }
    return _sectionModel;
}
@end
