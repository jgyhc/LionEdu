//
//  BLPaperViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLPaperViewController.h"
#import "BLGetTestPaperQuestionAPI.h"
#import <MJRefresh.h>
#import "BLQuestionsModel.h"
#import "ZLTableViewSectionModel.h"
#import <YYModel.h>
#import "ZLTableViewDelegateManager.h"
#import "BLPaperModel.h"
#import "AdaptScreenHelp.h"
#import "BLTopicViewController.h"
#import "UIViewController+ZLCustomNavigationBar.h"
#import "BLGetMockExamListAPI.h"
#import "BLAddGoodsCartAPI.h"
#import "BLPaperBuyAlertViewController.h"
#import <LCProgressHUD.h>
#import "BLMallOrderSureViewController.h"
#import <NSArray+BlocksKit.h>
#import "ZLUserInstance.h"

@interface BLPaperViewController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource, ZLTableViewDelegateManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomCon;

@property (nonatomic, strong) BLGetTestPaperQuestionAPI * getTestPaperQuestionAPI;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) BLQuestionsModel *questionsModel;

@property (nonatomic, strong) ZLTableViewSectionModel *sectionModel;

@property (nonatomic, strong) NSMutableArray * datas;

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) BLAddGoodsCartAPI *addGoodsCartAPI;

//全部已经购买
@property (nonatomic, assign) BOOL isAllDidBuy;

@end

@implementation BLPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.bottomView.hidden = YES;
    self.page = 1;
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.page = 1;
        [wself.getTestPaperQuestionAPI loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        wself.page ++;
        [wself.getTestPaperQuestionAPI loadData];
    }];
    
    self.customNavigationBar = [ZLCustomNavigationBar new];
    [self.customNavigationBar setLeftImage:[UIImage imageNamed:@"nav_black_back_icon"] status:ZLCustomNavigationBarStatusOpaque];
    [self.customNavigationBar setLeftImage:[UIImage imageNamed:@"nav_black_back_icon"] status:ZLCustomNavigationBarStatusTransparent];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setPaperParams:(NSDictionary *)paperParams {
    _paperParams = paperParams;
    _questionsModel = [BLQuestionsModel yy_modelWithJSON:paperParams];
}

- (IBAction)joinShoppingCartEvent:(id)sender {
    [self.addGoodsCartAPI loadData];
}

- (IBAction)buyEvent:(id)sender {
    
    BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
    
    BLPaperModel *paperModel = [BLPaperModel new];
    paperModel.goodsId = self.questionsModel.goodsId;
    paperModel.coverImg = self.questionsModel.img;
    paperModel.title = self.questionsModel.title;
    paperModel.price = self.questionsModel.price;
    viewController.paperModel = paperModel;
     
    
    /*
    viewController.goodsId = @(self.questionsModel.goodsId).stringValue;
    viewController.groupId = @"";
    //拼团类型：0：单独购买，1：发起拼团，2：参加拼团
    viewController.groupType = @0;
    */
    
    viewController.backToController = @"BLPaperViewController";
    [self.navigationController pushViewController:viewController animated:YES];
    
    /**
    __weak typeof(self) wself = self;
    BLPaperBuyAlertViewController *viewController =
       [[BLPaperBuyAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                                content:[NSString stringWithFormat:@"“%@”\n是否购买", _questionsModel.title]
                                                buttons:@[@{BLPaperBuyAlertControllerButtonTitleKey: @"立即购买",
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
                                                          ] tapBlock:^(BLPaperBuyAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
           if ([title isEqualToString:@"立即购买"]) {
               BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
               BLPaperModel *paperModel = [BLPaperModel new];
               paperModel.goodsId = self.questionsModel.goodsId;
               paperModel.coverImg = self.questionsModel.img;
               paperModel.title = self.questionsModel.title;
               paperModel.price = self.questionsModel.price;
               viewController.paperModel = paperModel;
               viewController.backToController = @"BLPaperViewController";
               [wself.navigationController pushViewController:viewController animated:YES];
           }
           }];
    viewController.textAlignment = NSTextAlignmentCenter;
    viewController.priceString = [NSString stringWithFormat:@"￥%0.2f", [_questionsModel.price doubleValue]];
    [self presentViewController:viewController animated:YES completion:nil];
     */
}

- (void)bl_buy {
    if (self.questionsModel.price.floatValue <= 0) {
        
    }
    BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
    BLPaperModel *paperModel = [BLPaperModel new];
    paperModel.goodsId = self.questionsModel.goodsId;
    paperModel.coverImg = self.questionsModel.img;
    paperModel.title = self.questionsModel.title;
    paperModel.price = self.questionsModel.price;
    viewController.paperModel = paperModel;
    viewController.backToController = @"BLPaperViewController";
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getTestPaperQuestionAPI isEqual:manager]) {
        return @{@"functionTypeId": @(_setId),
                 @"modelId": @(_modelId),
                 @"pageNum": @(_page),
                 @"pageSize": @30
                 };
    }
    if ([self.addGoodsCartAPI isEqual:manager]) {
        return @{@"goodsId": @(_questionsModel.goodsId),
                 @"goodsNum":@1,
                 @"cartPrice": _questionsModel.price?_questionsModel.price:@0
        };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getTestPaperQuestionAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            if (_page == 1) {
                [self.datas removeAllObjects];
                [self.datas addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLPaperHeaderTableViewCell";
                    rowModel.data = _questionsModel;
                    rowModel.cellHeight = StatusBarHeight() + 176;
                    rowModel;
                })];
            }
            NSDictionary *dic = [data objectForKey:@"data"];
            NSArray<BLPaperModel *> *list = [NSArray yy_modelArrayWithClass:[BLPaperModel class] json:[dic objectForKey:@"list"]];
//            NSArray <BLPaperModel *>* didBuys = [list bk_select:^BOOL(BLPaperModel *obj) {
//                if ([obj.isRare isEqualToString:@"1"]) {
//                    if ([obj.isPurchaseRare isEqualToString:@"1"]) {
//                        return YES;
//                    }
//                    return NO;
//                }
//                if ([obj.isPurchase isEqualToString:@"1"]) {
//                    return YES;
//                }
//                if ([obj.isFree isEqualToString:@"1"]) {
//                    return YES;
//                }
//                return NO;
//            }];
            BOOL isAllyBuy = [list bk_all:^BOOL(BLPaperModel *obj) {
                if ([obj.isRare isEqualToString:@"1"]) {
                   if ([obj.isPurchaseRare isEqualToString:@"1"]) {
                       return YES;
                   }
                   return NO;
               }
               if ([obj.isPurchase isEqualToString:@"1"]) {
                   return YES;
               }
               if ([obj.isFree isEqualToString:@"1"]) {
                   return YES;
               }
               return NO;
            }];
            
            if ([_questionsModel.isPurchase isEqualToString:@"1"] || [_questionsModel.isFree isEqualToString:@"1"] || [_questionsModel.price doubleValue] == 0.0) {//免费获赠已经购买
                self.bottomView.hidden = YES;
            }else {
                if (isAllyBuy) {
                    [list enumerateObjectsUsingBlock:^(BLPaperModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.isAllBuy = YES;
                    }];
                    _questionsModel.isAllBuy = YES;
                    self.isAllDidBuy = YES;
                    self.bottomView.hidden = YES;
                    self.tableViewBottomCon.constant = 0;
                } else {
                    self.bottomView.hidden = NO;
                    self.tableViewBottomCon.constant = 50;
                }
            }
            
            if (list.count < 30) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
//            NSString * isAllFree = _questionsModel.isFree;
            [list enumerateObjectsUsingBlock:^(BLPaperModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.isStart = _questionsModel.isStart;
                obj.isAdvance = _questionsModel.isAdvance;
                obj.advanceDate = _questionsModel.advanceDate;
                if (idx == 0) {
                    _questionsModel.eachPrice = obj.price;
                }
                [self.datas addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLPaperItemTableViewCell";
                    rowModel.data = obj;
                    rowModel.cellHeight = 78;
                    rowModel;
                })];
            }];
            [self.view layoutIfNeeded];
            [self.manager reloadData];
        }
    }
    if ([self.addGoodsCartAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [LCProgressHUD show:[data objectForKey:@"msg"]];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[self.sectionModel];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLPaperItemTableViewCell"]) {
        BLPaperModel *data = model.data;
        if (![ZLUserInstance sharedInstance].isLogin) {
            [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
            return;
        }
        BOOL isBuy = NO;
        if ([data.isFree isEqualToString:@"1"] || self.questionsModel.price.floatValue <= 0) {
            isBuy = YES;
        }else {
            if ([data.isRare isEqualToString:@"1"]) {
                if ([data.isPurchaseRare isEqualToString:@"1"]) {
                    isBuy = YES;
                }
            }else {
                if ([data.isPurchase isEqualToString:@"1"]) {
                    isBuy = YES;
                }
            }
        }
        
        if (isBuy) {
            if ([data.isAdvance isEqualToString:@"1"] && !data.isStart) {
                return;
            }
            BLTopicViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
           viewController.setId = data.Id;
           viewController.modelId = data.modelId;
           viewController.functionTypeId = data.functionTypeId;
           viewController.duration = [data.duration integerValue];
           [self.navigationController pushViewController:viewController animated:YES];
        }else {
            [self bl_buy];
        }
    }
        
//
//        if ([data.isFree isEqualToString:@"1"] || ([data.isPurchase isEqualToString:@"1"] && [data.isRare isEqualToString:@"0"]) || [data.isPurchase isEqualToString:@"1"]) {
//            if ([data.isAdvance isEqualToString:@"1"] && !data.isStart) {
//                return;
//            }
//            BLTopicViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
//            viewController.setId = data.Id;
//            viewController.modelId = data.modelId;
//            viewController.functionTypeId = data.functionTypeId;
//            viewController.duration = [data.duration integerValue];
//            [self.navigationController pushViewController:viewController animated:YES];
//        } else if ([data.isRare isEqualToString:@"1"] && [data.isPurchaseRare isEqualToString:@"1"]) {
//            if ([data.isAdvance isEqualToString:@"1"] && !data.isStart) {
//                return;
//            }
//            BLTopicViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
//            viewController.setId = data.Id;
//            viewController.modelId = data.modelId;
//            viewController.functionTypeId = data.functionTypeId;
//            viewController.duration = [data.duration integerValue];
//            [self.navigationController pushViewController:viewController animated:YES];
//        } else if ([data.isRare isEqualToString:@"1"]) {
//            if (self.questionsModel.price.floatValue <= 0) {
//                BLTopicViewController *viewController =  [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
//                viewController.setId = data.Id;
//                viewController.modelId = data.modelId;
//                viewController.duration = [data.duration integerValue];;
//                viewController.functionTypeId = data.functionTypeId;
//                [self.navigationController pushViewController:viewController animated:YES];
//                return;
//            }
//            [self bl_buy];
//            /**
//            NSArray *buttons = @[@{BLPaperBuyAlertControllerButtonTitleKey: @"立即购买",
//                        BLPaperBuyAlertControllerButtonTextColorKey: [UIColor whiteColor],
//                        BLPaperBuyAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
//                        BLPaperBuyAlertControllerButtonBorderColorKey: @1,
//                        BLPaperBuyAlertControllerButtonNormalBackgroundColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
//                        BLPaperBuyAlertControllerButtonRoundedCornersKey:@14.5
//            },
//                @{BLPaperBuyAlertControllerButtonTitleKey: @"取消",
//                        BLPaperBuyAlertControllerButtonTextColorKey: [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
//                        BLPaperBuyAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
//                        BLPaperBuyAlertControllerButtonBorderWidthKey: @1,
//                        BLPaperBuyAlertControllerButtonNormalBackgroundColorKey:[UIColor whiteColor],
//                        BLPaperBuyAlertControllerButtonRoundedCornersKey:@14.5
//            }
//            ];
//            __weak typeof(self) wself = self;
//            BLPaperBuyAlertViewController *viewController =
//               [[BLPaperBuyAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
//                                                        content:@"购买立即解锁所有稀罕"
//                                                        buttons:buttons tapBlock:^(BLPaperBuyAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
//                   if ([title isEqualToString:@"立即购买"]) {
//                       BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
//                       BLPaperModel *paperModel = [BLPaperModel new];
//                       paperModel.goodsId = self.questionsModel.goodsId;
//                       paperModel.coverImg = self.questionsModel.img;
//                       paperModel.title = self.questionsModel.title;
//                       paperModel.price = self.questionsModel.price;
//                       viewController.paperModel = paperModel;
//                       viewController.backToController = @"BLPaperViewController";
//                       [wself.navigationController pushViewController:viewController animated:YES];
//                   }
//                   }];
//            viewController.textAlignment = NSTextAlignmentCenter;
//            viewController.priceString = [NSString stringWithFormat:@"￥%0.2f/套", [self.questionsModel.price doubleValue]];
//            [self presentViewController:viewController animated:YES completion:nil];
//            */
//
//        } else {
//            if (self.questionsModel.price.floatValue <= 0) {
//                BLTopicViewController *viewController =  [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
//                viewController.setId = data.Id;
//                viewController.modelId = data.modelId;
//                viewController.duration = [data.duration integerValue];;
//                viewController.functionTypeId = data.functionTypeId;
//                [self.navigationController pushViewController:viewController animated:YES];
//                return;
//            }
//            [self bl_buy];
//            /**
//            NSArray *buttons = @[@{BLPaperBuyAlertControllerButtonTitleKey: @"立即购买",
//                        BLPaperBuyAlertControllerButtonTextColorKey: [UIColor whiteColor],
//                        BLPaperBuyAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
//                        BLPaperBuyAlertControllerButtonBorderColorKey: @1,
//                        BLPaperBuyAlertControllerButtonNormalBackgroundColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
//                        BLPaperBuyAlertControllerButtonRoundedCornersKey:@14.5
//            },
//                @{BLPaperBuyAlertControllerButtonTitleKey: @"取消",
//                        BLPaperBuyAlertControllerButtonTextColorKey: [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
//                        BLPaperBuyAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
//                        BLPaperBuyAlertControllerButtonBorderWidthKey: @1,
//                        BLPaperBuyAlertControllerButtonNormalBackgroundColorKey:[UIColor whiteColor],
//                        BLPaperBuyAlertControllerButtonRoundedCornersKey:@14.5
//            }
//            ];
//            __weak typeof(self) wself = self;
//            BLPaperBuyAlertViewController *viewController =
//               [[BLPaperBuyAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
//                                                        content:[NSString stringWithFormat:@"%@\n”购买解锁，继续作答“", data.title]
//                                                        buttons:buttons tapBlock:^(BLPaperBuyAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
//                   if ([title isEqualToString:@"立即购买"]) {
//                       BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
//                       BLPaperModel *paperModel = [BLPaperModel new];
//                       paperModel.goodsId = self.questionsModel.goodsId;
//                       paperModel.coverImg = self.questionsModel.img;
//                       paperModel.title = self.questionsModel.title;
//                       paperModel.price = self.questionsModel.price;
//                       viewController.paperModel = paperModel;
//                       viewController.backToController = @"BLPaperViewController";
//                       [wself.navigationController pushViewController:viewController animated:YES];
//                   }
//                   }];
//            viewController.textAlignment = NSTextAlignmentCenter;
//            viewController.priceString = [NSString stringWithFormat:@"￥%0.2f/套", [self.questionsModel.price doubleValue]];
//            [self presentViewController:viewController animated:YES completion:nil];
//             */
//        }
//    }
}

- (BLGetTestPaperQuestionAPI *)getTestPaperQuestionAPI {
    if (!_getTestPaperQuestionAPI) {
        _getTestPaperQuestionAPI = [[BLGetTestPaperQuestionAPI alloc] init];
        _getTestPaperQuestionAPI.mj_delegate = self;
        _getTestPaperQuestionAPI.paramSource = self;
    }
    return _getTestPaperQuestionAPI;
}

- (ZLTableViewSectionModel *)sectionModel {
    if (!_sectionModel) {
        _sectionModel = [ZLTableViewSectionModel new];
        _sectionModel.items = self.datas;
    }
    return _sectionModel;
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (BLAddGoodsCartAPI *)addGoodsCartAPI {
    if (!_addGoodsCartAPI) {
        _addGoodsCartAPI = [[BLAddGoodsCartAPI alloc] init];
        _addGoodsCartAPI.mj_delegate = self;
        _addGoodsCartAPI.paramSource = self;
    }
    return _addGoodsCartAPI;
}

@end
