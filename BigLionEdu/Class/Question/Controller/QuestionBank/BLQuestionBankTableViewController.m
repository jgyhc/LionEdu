//
//  BLQuestionBankTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLQuestionBankTableViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLGetBaseTypeByIdTypeAPI.h"
#import "BLQuestionsClassificationModel.h"
#import <YYModel.h>
#import <MJRefresh.h>
#import <MJPlaceholder.h>
#import "BLGetTestPaperQuestionAPI.h"
#import "BLPaperModel.h"
#import "BLTopicViewController.h"
#import "BLGetFunctionTypeAPI.h"
#import "BLPaperViewController.h"
#import "BLPaperBuyAlertViewController.h"
#import "BLMallOrderSureViewController.h"
#import "ZLUserInstance.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@interface BLQuestionBankTableViewController ()<ZLTableViewDelegateManagerDelegate, CTAPIManagerParamSource, MJAPIBaseManagerDelegate, BLQuestionsClassificationModelDelegate>
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) BLGetBaseTypeByIdTypeAPI *getBaseTypeByIdTypeAPI;
@property (nonatomic, strong) BLGetFunctionTypeAPI *getFunctionTypeAPI;
@property (nonatomic, strong) ZLTableViewSectionModel *sectionModel;
@property (nonatomic, strong) BLQuestionsClassificationModel *currentModel;
@property (nonatomic, strong) NSArray * list;
@end

@implementation BLQuestionBankTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself.getFunctionTypeAPI loadData];
    }];
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"没有相关数据哦",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
    [self.tableView.mj_header beginRefreshing];
}

- (void)reloadData {
    [self.tableView.mj_header beginRefreshing];
}

- (UIView *)listView {
    return self.view;
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[self.sectionModel];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    if ([model.identifier isEqualToString:@"BLQuestionBankHeaderTableViewCell"]) {
        BLPaperViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLPaperViewController"];
        BLQuestionsClassificationModel *obj = model.data;
        viewController.paperParams = [model.data yy_modelToJSONObject];
        viewController.modelId = _modelId;
        viewController.setId = obj.Id;
        [self.superViewController.navigationController pushViewController:viewController animated:YES];
    }
    if ([model.identifier isEqualToString:@"BLQuestionBankItemTableViewCell"]) {
        BLPaperModel *data = model.data;
        if ([data.isFree isEqualToString:@"1"] || ([data.isPurchase isEqualToString:@"1"] && [data.isRare isEqualToString:@"0"])) {
            if ([data.isAdvance isEqualToString:@"1"] && !data.isStart) {
                return;
            }
            BLTopicViewController *viewController =  [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
            viewController.setId = data.Id;
            viewController.modelId = data.modelId;
            viewController.duration = [data.duration integerValue];;
            viewController.functionTypeId = data.functionTypeId;
            [self.superViewController.navigationController pushViewController:viewController animated:YES];
        } else if ([data.isRare isEqualToString:@"1"] && [data.isPurchaseRare isEqualToString:@"1"]) {
            if ([data.isAdvance isEqualToString:@"1"] && !data.isStart) {
                return;
            }
            BLTopicViewController *viewController =  [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
            viewController.setId = data.Id;
            viewController.modelId = data.modelId;
            viewController.duration = [data.duration integerValue];;
            viewController.functionTypeId = data.functionTypeId;
            [self.superViewController.navigationController pushViewController:viewController animated:YES];
            /** 是否稀罕：1:稀罕， 0：不是 */
        } else if ([data.isRare isEqualToString:@"1"]) {
            if (data.price.floatValue <= 0) {
                BLTopicViewController *viewController =  [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
                viewController.setId = data.Id;
                viewController.modelId = data.modelId;
                viewController.duration = [data.duration integerValue];;
                viewController.functionTypeId = data.functionTypeId;
                [self.superViewController.navigationController pushViewController:viewController animated:YES];
                return;
            }
            BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
            viewController.paperModel = data;
            viewController.backToController = @"BLQuestionBankTableViewController";
            [self.superViewController.navigationController pushViewController:viewController animated:YES];
            /**
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
            __weak typeof(self) wself = self;
            BLPaperBuyAlertViewController *viewController =
               [[BLPaperBuyAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                                        content:@"购买立即解锁所有稀罕"
                                                        buttons:buttons tapBlock:^(BLPaperBuyAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
                   if ([title isEqualToString:@"立即购买"]) {
                       BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
                       viewController.paperModel = data;
                       viewController.backToController = @"BLQuestionBankTableViewController";
                       [wself.superViewController.navigationController pushViewController:viewController animated:YES];
                   }
                   }];
            viewController.textAlignment = NSTextAlignmentCenter;
            viewController.priceString = [NSString stringWithFormat:@"￥%0.2f/套", [data.price doubleValue]];
            [self.superViewController presentViewController:viewController animated:YES completion:nil];
             */
        } else {
            if (data.price.floatValue <= 0) {
                BLTopicViewController *viewController =  [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
                viewController.setId = data.Id;
                viewController.modelId = data.modelId;
                viewController.duration = [data.duration integerValue];;
                viewController.functionTypeId = data.functionTypeId;
                [self.superViewController.navigationController pushViewController:viewController animated:YES];
                return;
            }
            BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
            viewController.paperModel = data;
            viewController.backToController = @"BLQuestionBankTableViewController";
            [self.superViewController.navigationController pushViewController:viewController animated:YES];
            /**
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
            __weak typeof(self) wself = self;
            BLPaperBuyAlertViewController *viewController =
               [[BLPaperBuyAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                                        content:[NSString stringWithFormat:@"%@\n”购买解锁，继续作答“", data.title]
                                                        buttons:buttons tapBlock:^(BLPaperBuyAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
                   if ([title isEqualToString:@"立即购买"]) {
                       BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
                       viewController.paperModel = data;
                       viewController.backToController = @"BLQuestionBankTableViewController";
                       [wself.superViewController.navigationController pushViewController:viewController animated:YES];
                   }
                   }];
            viewController.textAlignment = NSTextAlignmentCenter;
            viewController.priceString = [NSString stringWithFormat:@"￥%0.2f/套", [data.price doubleValue]];
            [self.superViewController presentViewController:viewController animated:YES completion:nil];
            */
        }
    }
}


- (void)updateTableView {
    NSMutableArray *array = [NSMutableArray array];
    [_list enumerateObjectsUsingBlock:^(BLQuestionsClassificationModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.currentRowModel];
        if (obj.open && obj.subCellModels.count > 0) {
            [array addObjectsFromArray:obj.subCellModels];
        }
    }];
    self.sectionModel.items = array;
    [self.manager reloadData];
}

- (void)headerCellDidSelect:(BLQuestionsClassificationModel *)obj {
    _currentModel = obj;
    obj.open = !obj.open;
    if (!obj.subCellModels) {
        [obj reloadData];
    }else {
        [self updateTableView];
    }
    [self.tableView reloadData];
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getBaseTypeByIdTypeAPI isEqual:manager]) {
        return @{
                 @"modelId": @(_modelId),
                 @"functionType":@1
                 };
    } else if ([manager isEqual:self.getFunctionTypeAPI]) {
        return @{@"modelId": @(_modelId),
                 @"functionTypeId": @(_parentId)
        };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if ([self.getFunctionTypeAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray *list = [NSArray yy_modelArrayWithClass:[BLQuestionsClassificationModel class] json:[data objectForKey:@"data"]];
            _list = list;
            [list enumerateObjectsUsingBlock:^(BLQuestionsClassificationModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.searchTitle = _searchTitle;
                obj.years = _years;
                obj.startYears = _startYears;
                obj.entYears = _endYears;
                obj.province = _province;
                obj.city = _city;
                obj.area = _area;
                obj.delegate = self;
            }];
            [self updateTableView];
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

- (BLGetBaseTypeByIdTypeAPI *)getBaseTypeByIdTypeAPI {
    if (!_getBaseTypeByIdTypeAPI) {
        _getBaseTypeByIdTypeAPI = [[BLGetBaseTypeByIdTypeAPI alloc] init];
        _getBaseTypeByIdTypeAPI.mj_delegate = self;
        _getBaseTypeByIdTypeAPI.paramSource = self;
    }
    return _getBaseTypeByIdTypeAPI;
}

- (BLGetFunctionTypeAPI *)getFunctionTypeAPI {
    if (!_getFunctionTypeAPI) {
        _getFunctionTypeAPI = [[BLGetFunctionTypeAPI alloc] init];
        _getFunctionTypeAPI.mj_delegate = self;
        _getFunctionTypeAPI.paramSource = self;
    }
    return _getFunctionTypeAPI;
}

- (ZLTableViewSectionModel *)sectionModel {
    if (!_sectionModel) {
        _sectionModel = [ZLTableViewSectionModel new];
    }
    return _sectionModel;
}

@end
