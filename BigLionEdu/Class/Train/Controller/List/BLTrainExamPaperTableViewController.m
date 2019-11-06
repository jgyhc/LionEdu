//
//  BLTrainExamPaperTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainExamPaperTableViewController.h"
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
#import "BLQuestionsModel.h"
#import "BLPaperBuyAlertViewController.h"
#import <LCProgressHUD.h>
#import "BLMallOrderSureViewController.h"
#import "ZLUserInstance.h"
#import "BLTopicViewController.h"
#import "UIViewController+ORAdd.h"


@interface BLTrainExamPaperTableViewController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) BLGetTestPaperQuestionAPI * getTestPaperQuestionAPI;

@property (nonatomic, strong) NSMutableArray * datas;

@property (nonatomic, strong) BLQuestionsModel *questionsModel;
//全部已经购买
@property (nonatomic, assign) BOOL isAllDidBuy;
@end

@implementation BLTrainExamPaperTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.manager reloadData];
    _page = 1;
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.page = 1;
        [wself.getTestPaperQuestionAPI loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        wself.page ++;
        [wself.getTestPaperQuestionAPI loadData];
    }];
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"暂无数据",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
    [self.tableView.mj_header beginRefreshing];
}

- (void)setPaperParams:(NSDictionary *)paperParams {
    _paperParams = paperParams;
    _questionsModel = [BLQuestionsModel yy_modelWithJSON:paperParams];
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
    BLPaperModel *data = model.data;
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    if ([data.isFree isEqualToString:@"1"] || ([data.isPurchase isEqualToString:@"1"] && [data.isRare isEqualToString:@"0"])) {
        if ([data.isAdvance isEqualToString:@"1"] && !data.isStart) {
            return;
        }
        BLTopicViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
        viewController.setId = data.Id;
        viewController.modelId = data.modelId;
        viewController.functionTypeId = data.functionTypeId;
        viewController.duration = [data.duration integerValue];
        [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
    } else if ([data.isRare isEqualToString:@"1"] && [data.isPurchaseRare isEqualToString:@"1"]) {
        if ([data.isAdvance isEqualToString:@"1"] && !data.isStart) {
            return;
        }
        BLTopicViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
        viewController.setId = data.Id;
        viewController.modelId = data.modelId;
        viewController.functionTypeId = data.functionTypeId;
        viewController.duration = [data.duration integerValue];
        [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
    } else if ([data.isRare isEqualToString:@"1"]) {
        NSArray *buttons = @[@{BLPaperBuyAlertControllerButtonTitleKey: @"立即购买",
                    BLPaperBuyAlertControllerButtonTextColorKey: [UIColor whiteColor],
                    BLPaperBuyAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                    BLPaperBuyAlertControllerButtonBorderColorKey: @1,
                    BLPaperBuyAlertControllerButtonNormalBackgroundColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                    BLPaperBuyAlertControllerButtonRoundedCornersKey:@14.5
        },
            @{BLPaperBuyAlertControllerButtonTitleKey: @"取消",
                    BLPaperBuyAlertControllerButtonTextColorKey: [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                    BLPaperBuyAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                    BLPaperBuyAlertControllerButtonBorderWidthKey: @1,
                    BLPaperBuyAlertControllerButtonNormalBackgroundColorKey:[UIColor whiteColor],
                    BLPaperBuyAlertControllerButtonRoundedCornersKey:@14.5
        }
        ];
//        __weak typeof(self) wself = self;
        BLPaperBuyAlertViewController *viewController =
           [[BLPaperBuyAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                                    content:@"购买立即解锁所有稀罕"
                                                    buttons:buttons tapBlock:^(BLPaperBuyAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
               if ([title isEqualToString:@"立即购买"]) {
                   BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
                   viewController.paperModel = data;
                   viewController.backToController = @"BLPaperViewController";
                   [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
               }
               }];
        viewController.textAlignment = NSTextAlignmentCenter;
        viewController.priceString = [NSString stringWithFormat:@"￥%0.2f", [data.price doubleValue]];
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        NSArray *buttons = @[@{BLPaperBuyAlertControllerButtonTitleKey: @"立即购买",
                    BLPaperBuyAlertControllerButtonTextColorKey: [UIColor whiteColor],
                    BLPaperBuyAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                    BLPaperBuyAlertControllerButtonBorderColorKey: @1,
                    BLPaperBuyAlertControllerButtonNormalBackgroundColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                    BLPaperBuyAlertControllerButtonRoundedCornersKey:@14.5
        },
            @{BLPaperBuyAlertControllerButtonTitleKey: @"取消",
                    BLPaperBuyAlertControllerButtonTextColorKey: [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                    BLPaperBuyAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                    BLPaperBuyAlertControllerButtonBorderWidthKey: @1,
                    BLPaperBuyAlertControllerButtonNormalBackgroundColorKey:[UIColor whiteColor],
                    BLPaperBuyAlertControllerButtonRoundedCornersKey:@14.5
        }
        ];
//        __weak typeof(self) wself = self;
        BLPaperBuyAlertViewController *viewController =
           [[BLPaperBuyAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                                    content:[NSString stringWithFormat:@"%@\n”购买解锁，继续作答“", data.title]
                                                    buttons:buttons tapBlock:^(BLPaperBuyAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
               if ([title isEqualToString:@"立即购买"]) {
                   BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
                   viewController.paperModel = data;
                   viewController.backToController = @"BLPaperViewController";
                   [[UIViewController currentViewController].navigationController pushViewController:viewController animated:YES];
               }
               }];
        viewController.textAlignment = NSTextAlignmentCenter;
        viewController.priceString = [NSString stringWithFormat:@"￥%0.2f", [data.price doubleValue]];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getTestPaperQuestionAPI isEqual:manager]) {
        return @{
                 @"functionTypeId":@(_functionTypeId),
                 @"modelId":@(_modelId),
//                 @"type":@(_type),
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
    if ([self.getTestPaperQuestionAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            if (_page == 1) {
               [self.datas removeAllObjects];
            }
            NSDictionary *dic = [data objectForKey:@"data"];
            NSArray<BLPaperModel *> *list = [NSArray yy_modelArrayWithClass:[BLPaperModel class] json:[dic objectForKey:@"list"]];

            NSArray <BLPaperModel *>* didBuys = [list bk_select:^BOOL(BLPaperModel *obj) {
               return [obj.isFree isEqualToString:@"1"] || [obj.isPurchase isEqualToString:@"1"];
            }];
            if (didBuys.count == list.count) {
               self.isAllDidBuy = YES;
            }
            if (list.count < 30) {
               [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [list enumerateObjectsUsingBlock:^(BLPaperModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               obj.isStart = _questionsModel.isStart;
               obj.isAdvance = _questionsModel.isAdvance;
               obj.advanceDate = _questionsModel.advanceDate;
               if (idx == 0) {
                   _questionsModel.eachPrice = obj.price;
               }
               [self.datas addObject:({
                   ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                   rowModel.identifier = @"BLTrainExamPaperTableViewCell";
                   rowModel.data = obj;
                   rowModel.cellHeight = 78;
                   rowModel;
               })];
            }];
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

- (BLGetTestPaperQuestionAPI *)getTestPaperQuestionAPI {
    if (!_getTestPaperQuestionAPI) {
        _getTestPaperQuestionAPI = [[BLGetTestPaperQuestionAPI alloc] init];
        _getTestPaperQuestionAPI.paramSource = self;
        _getTestPaperQuestionAPI.mj_delegate = self;
    }
    return _getTestPaperQuestionAPI;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

@end
