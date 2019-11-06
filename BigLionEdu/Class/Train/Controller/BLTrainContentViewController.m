//
//  BLTrainContentViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/21.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainContentViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAppAccompanyGetAppAccompanyInfoAPI.h"
#import "BLTrainListModel.h"
#import <YYModel.h>
#import "BLTrainSubTableViewCell.h"
#import "BLTrainMenuTableViewCell.h"
#import "BLQuestionListViewController.h"
#import "BLQuestionBankViewController.h"
#import "BLTrainListViewController.h"
#import "BLHeadlinesViewController.h"
#import "BLTrainBookrackTableViewCell.h"
#import "BLVideoClassDetailViewController.h"
#import "UIViewController+ORAdd.h"
#import "BLTrainHotTableViewCell.h"
#import "BLHeadlineDetailViewController.h"
#import "UIViewController+ORAdd.h"
#import <MJRefresh.h>
#import <LCProgressHUD.h>
#import "BLGoodsDetailViewController.h"

@interface BLTrainContentViewController ()<ZLTableViewDelegateManagerDelegate, CTAPIManagerParamSource, MJAPIBaseManagerDelegate, BLTrainSubTableViewCellDelegate, BLTrainMenuTableViewCellDelegate, BLTrainBookrackTableViewCellDelegate, BLTrainHotTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;

@property (nonatomic, strong) BLAppAccompanyGetAppAccompanyInfoAPI * appAccompanyGetAppAccompanyInfoAPI;

@property (nonatomic, strong) BLTrainListModel * model;

@property (nonatomic, strong) NSArray * datas;

@property (nonatomic, strong) BLTrainBaseTitleModel * currentTitleModel;

@property (nonatomic, strong) ZLTableViewSectionModel * classSectionModel;


@end

@implementation BLTrainContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself.appAccompanyGetAppAccompanyInfoAPI loadData];
    }];
    [self.appAccompanyGetAppAccompanyInfoAPI loadData];

}

- (void)setIndex:(NSInteger)index {
    _index = index;
}

- (void)didSelectMenuWithModel:(BLTrainIndexFunctionsModel *)model {
    if (model.type == 1) {//类型 1: 题库， 0：课程， 2： 商城， 3： 面试
        if (_modelId == 12) {
            BLQuestionListViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]]
                                                            instantiateViewControllerWithIdentifier:@"BLQuestionListViewController"];
            viewController.modelId = _modelId;
            [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
        }else {
            BLQuestionBankViewController * viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]]
                                                             instantiateViewControllerWithIdentifier:@"BLQuestionBankViewController"];
            viewController.modelId = _modelId;
            [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
        }
//        BLQuestionBankViewController * viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]]
//                                                         instantiateViewControllerWithIdentifier:@"BLQuestionBankViewController"];
//        viewController.modelId = _modelId;
//        [self.superViewController.navigationController pushViewController:viewController animated:YES];
        
    }
    if (model.type == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TO_MALL" object:@(self.index)];
        [[UIViewController currentViewController].navigationController.tabBarController setSelectedIndex:2];
    }
    
    if (model.type == 0 || model.type == 3) {//类型 1: 题库， 0：课程， 2： 商城， 3： 面试
        BLTrainListViewController *viewController = [[BLTrainListViewController alloc] init];
        viewController.modelId = _modelId;
        viewController.functionType = model.type;
        [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
    }
    
    if (model.type == 4 || model.type == 5) {
        BLTrainListViewController *viewController = [[BLTrainListViewController alloc] init];
        viewController.modelId = _modelId;
        viewController.functionType = model.type;
        [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
    }
}

/**
 如果列表是VC，就返回VC.view
 如果列表是View，就返回View自己
 
 @return 返回列表视图
 */
- (UIView *)listView {
    return self.view;
}

- (IBAction)handlerMenuEvent:(id)sender {
//    if (_modelId == 12) {
//        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLQuestionListViewController"];
//        [self.superViewController.navigationController pushViewController:viewController animated:YES];
//    }else {
//        BLQuestionBankViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLQuestionBankViewController"];
//        [self.superViewController.navigationController pushViewController:viewController animated:YES];
//    }

}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLTrainHotTableViewCell"]) {
        BLHeadlinesViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLHeadlinesViewController"];
        viewController.modelId = _modelId;
        [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];

    }
    if ([model.identifier isEqualToString:@"BLTrainMockTableViewCell"]) {
        BLQuestionBankViewController * viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]]
                                                         instantiateViewControllerWithIdentifier:@"BLQuestionBankViewController"];
        viewController.type = 1;
        viewController.modelId = _modelId;
        [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
    }
    
    if ([model.identifier isEqualToString:@"BLTrainItemTableViewCell"]) {
        BLTrainBaseCoreLiveRecListModel *data = model.data;
        BLVideoClassDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLVideoClassDetailViewController"];
        viewController.recId = [data.Id integerValue];
        [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
    }
    
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return _datas;
}

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.appAccompanyGetAppAccompanyInfoAPI isEqual:manager]) {
        return @{@"modelId": @(_modelId)};
    }
    return nil;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    [self.tableView.mj_header endRefreshing];
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    if (code != 200) {
        return;
    }
    id model = [data objectForKey:@"data"];
    if ([self.appAccompanyGetAppAccompanyInfoAPI isEqual:manager]) {
        BLTrainListModel *dataModel = [BLTrainListModel yy_modelWithJSON:model];
        self.model = dataModel;
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
}

- (void)updateEventWithIndex:(NSInteger)index model:(BLTrainBaseTitleModel *)model {
    NSMutableArray *list = [self.classSectionModel.items mutableCopy];
    [list removeObjectsInArray:_currentTitleModel.items];
    _currentTitleModel = model;
    [list addObjectsFromArray:_currentTitleModel.items];
    self.classSectionModel.items = list;
    [self.manager reloadData];
}

- (void)didSelectAllEvent:(NSInteger)index {
    if (index == 0) {
        BLTrainListViewController *viewController = [[BLTrainListViewController alloc] init];
        viewController.modelId = _modelId;
        viewController.functionType = 0;
        [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
    }else {
        UIViewController *viewController = [[CTMediator sharedInstance] performTarget:@"faceClass" action:@"faceClassViewController" params:@{@"modelId": @(_modelId),
                                                                                                                                              @"functionTypeId": @(0)
        } shouldCacheTarget:YES];
        [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
    }
    
}

- (void)setModel:(BLTrainListModel *)model {
    _model = model;
    NSMutableArray *list = [NSMutableArray array];
    
    if (model.moduleBanners.count > 0 || model.indexFunctions.count > 0) {
        [list addObject:({
            ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
            sectionModel.headerHeight = 10;
            sectionModel.headerBackgroundColor = [UIColor whiteColor];
            NSMutableArray *items = [NSMutableArray array];
            sectionModel.items = items;
            if (model.moduleBanners.count > 0) {
                [items addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLTrainBannerTableViewCell";
                    rowModel.cellHeight = 150;
                    rowModel.data = model.moduleStrBanners;
                    rowModel;
                })];
            }
            if (model.indexFunctions.count > 0) {
                [items addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLTrainMenuTableViewCell";
                    rowModel.cellHeight = 100;
                    rowModel.delegate = self;
                    rowModel.data = model.indexFunctions;
                    rowModel;
                })];
            }
            sectionModel;
        })];
        if (model.coreNews.count > 0) {
            [list addObject:({
                ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
                sectionModel.headerHeight = 10;
                sectionModel.headerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
                NSMutableArray *items = [NSMutableArray array];
                sectionModel.items = items;
                [items addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLTrainHotTableViewCell";
                    rowModel.cellHeight = 121;
                    rowModel.data = model.coreNews;
                    rowModel.delegate = self;
                    rowModel;
                })];
                sectionModel;
            })];
        }
        
        if (model.indexTest) {
            [list addObject:({
                ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
                sectionModel.headerHeight = 10;
                sectionModel.headerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
                NSMutableArray *items = [NSMutableArray array];
                sectionModel.items = items;
                [items addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLTrainMockTableViewCell";
                    rowModel.cellHeight = 121;
                    rowModel.data = model.indexTest;
                    rowModel;
                })];
                sectionModel;
            })];
        }
        
        if (model.recommendBookDTO) {
            [list addObject:({
                ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
                sectionModel.headerHeight = 10;
                sectionModel.headerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
                NSMutableArray *items = [NSMutableArray array];
                sectionModel.items = items;
                [items addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLTrainBookrackTableViewCell";
                    rowModel.cellHeight = 299;
                    rowModel.delegate = self;
                    rowModel.data = model.recommendBookDTO;
                    rowModel;
                })];
                sectionModel;
            })];
        }
        
        if (model.baseTitleDTOS.count > 0) {
            [list addObject:({
                ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
                sectionModel.headerHeight = 10;
                sectionModel.headerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
                NSMutableArray *items = [NSMutableArray array];
                sectionModel.items = items;
                _classSectionModel = sectionModel;
                [items addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLTrainSubTableViewCell";
                    rowModel.cellHeight = 45;
                    rowModel.delegate = self;
                    rowModel.data = model.baseTitleDTOS;
                    rowModel;
                })];
                _currentTitleModel = [model.baseTitleDTOS firstObject];
                [items addObjectsFromArray:_currentTitleModel.items];
                sectionModel;
            })];
        }
        
    }
    _datas = list;
    [self.manager reloadData];
}

- (void)didSelectHot:(BLTrainCoreNewsModel *)model {
    BLHeadlineDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLHeadlineDetailViewController"];
    viewController.newId = model.Id;
    [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
}

- (void)handlerBookrackDetail:(BLTrainCoreDoodsListModel *)model {
    //    0：书籍 1：试卷2：直播3：套卷(套卷都不显示）4:录播
    if ([model.type isEqualToString:@"0"] || [model.type isEqualToString:@"1"]) {
        BLGoodsDetailViewController *viewControlelr = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLGoodsDetailViewController"];
        viewControlelr.goodsId = [NSString stringWithFormat:@"%ld", (long)model.Id];
        [[UIViewController currentViewController].navigationController  pushViewController:viewControlelr animated:YES];
    } else if ([model.type isEqualToString:@"4"]) {
        BLVideoClassDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLVideoClassDetailViewController"];
        viewController.recId = model.Id;
        [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
    } else if ([model.type isEqualToString:@"2"]) {
        [LCProgressHUD show:@"直播功能正在开发中..."];
    }
    
    
//    BLVideoClassDetailViewController *viewControoler = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLVideoClassDetailViewController"];
//    viewControoler.recId = model.Id;
//    [[UIViewController currentViewController].navigationController pushViewController:viewControoler animated:YES];
}

- (void)handlerJumpShelfDetails {
    [[UIViewController currentViewController].navigationController.tabBarController setSelectedIndex:2];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (BLAppAccompanyGetAppAccompanyInfoAPI *)appAccompanyGetAppAccompanyInfoAPI {
    if (!_appAccompanyGetAppAccompanyInfoAPI) {
        _appAccompanyGetAppAccompanyInfoAPI = [[BLAppAccompanyGetAppAccompanyInfoAPI alloc] init];
        _appAccompanyGetAppAccompanyInfoAPI.paramSource = self;
        _appAccompanyGetAppAccompanyInfoAPI.mj_delegate = self;
    }
    return _appAccompanyGetAppAccompanyInfoAPI;
}

@end
