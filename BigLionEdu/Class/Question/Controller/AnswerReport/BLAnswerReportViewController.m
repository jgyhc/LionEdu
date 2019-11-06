//
//  BLAnswerReportViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAnswerReportViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAnswerReportListHeaderTableViewCell.h"
#import "BLGetMySummaryAPI.h"
#import "BLAnswerReportModel.h"
#import <YYModel.h>
#import "BLAnswerReportClassificationTableViewCell.h"
#import "BLAnswerSheetViewController.h"
#import "BLAnswerSheetNavViewController.h"
#import "BLTopicViewController.h"
#import <NSArray+BlocksKit.h>
#import <LCProgressHUD.h>
#import "BLGetAppSubtitleTypeListAPI.h"
#import "BLAnswerReportQuestionListModel.h"
#import "BLPaperViewController.h"
#import "BLVideoClassDetailViewController.h"
#import "BLGetQuestionListAPI.h"

@interface BLAnswerReportViewController ()<ZLTableViewDelegateManagerDelegate, BLAnswerReportListHeaderTableViewCellDelegate, CTAPIManagerParamSource, MJAPIBaseManagerDelegate, BLAnswerReportClassificationTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ZLTableViewDelegateManager * manager;

@property (nonatomic, strong) ZLTableViewSectionModel * footerSectionModels;

@property (nonatomic, strong) NSMutableArray * footerItems;

@property (nonatomic, strong) NSArray * footerHeaderItems;

@property (nonatomic, strong) BLGetMySummaryAPI * getMySummaryAPI;

@property (nonatomic, strong) ZLTableViewSectionModel *sectionModel;

@property (nonatomic, strong) BLGetAppSubtitleTypeListAPI * getAppSubtitleTypeListAPI;

@property (nonatomic, strong) BLAnswerReportModel * model;

@property (nonatomic, strong) NSArray * itemList;

@property (nonatomic, strong) BLAnswerReportQuestionListModel * currentListModel;

@property (nonatomic, strong) ZLTableViewRowModel * listHeaderRowModel;

@property (nonatomic, strong) BLGetQuestionListAPI *getQuestionListAPI;
@end

@implementation BLAnswerReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _footerHeaderItems = @[
                           ({
                               ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                               rowModel.identifier = @"BLAnswerReportTopRoundedCornersTableViewCell";
                               rowModel.cellHeight = 15;
                               rowModel;
                           }),
                           ({
                               ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                               rowModel.identifier = @"BLAnswerReportListHeaderTableViewCell";
                               _listHeaderRowModel = rowModel;
                               rowModel.cellHeight = 30;
                               rowModel.delegate = self;
                               rowModel;
                           })];
//    [self selectType:0];
    [self.getMySummaryAPI loadData];
    [self.getAppSubtitleTypeListAPI loadData];
    if (!_paperModel) {
        [self.getQuestionListAPI loadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma BLAnswerReportListHeaderTableViewCellDelegate method
- (void)selectTypeWithModel:(BLAnswerReportQuestionListModel *)model {
    [self.footerItems removeAllObjects];
    [self.footerItems addObjectsFromArray:_footerHeaderItems];
    [model.liveRecDTOList enumerateObjectsUsingBlock:^(BLAnswerReportQuestionItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.position isEqualToString:@"1"] || [model.position isEqualToString:@"2"]) {// 1：首页， 2：答题卡， 3：直播、录播 ，4:面授 ,
            [self.footerItems addObject:({
                ZLTableViewRowModel *model = [ZLTableViewRowModel new];
                model.identifier = @"BLAnswerReportTopicTableViewCell";
                model.cellHeight = 101;
                model.data = obj;
                model;
            })];
        }else {
            [self.footerItems addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLAnswerReportClassTableViewCell";
                rowModel.cellHeight = 116;
                rowModel.data = obj;
                rowModel;
            })];
        }
    }];
    
    [self.manager reloadData];
}

- (IBAction)backEvent:(id)sender {
//    UIViewController *viewController = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 4];
//    [self.navigationController popToViewController:viewController animated:YES];
    for (NSInteger index = self.navigationController.viewControllers.count - 1; index >= 0; index--) {
        UIViewController *viewController = self.navigationController.viewControllers[index];
        if(![viewController isKindOfClass:NSClassFromString(@"BLTopicViewController")] && ![viewController isKindOfClass:NSClassFromString(@"BLAnswerSheetViewController")]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
//    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[self.sectionModel, self.footerSectionModels];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLAnswerReportTopicTableViewCell"]) {
        BLAnswerReportQuestionItemModel *data = model.data;
        BLPaperViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLPaperViewController"];
        viewController.paperParams = [data yy_modelToJSONObject];
        viewController.modelId = _modelId;
        viewController.setId = data.Id;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    if ([model.identifier isEqualToString:@"BLAnswerReportClassTableViewCell"]) {
        BLAnswerReportQuestionItemModel *data = model.data;
        BLVideoClassDetailViewController *viewControoler = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLVideoClassDetailViewController"];
        viewControoler.recId = data.Id;
        [self.navigationController pushViewController:viewControoler animated:YES];
    }
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getMySummaryAPI isEqual:manager]) {
        return @{
                    @"functionTypeId":@(_functionTypeId),
                    @"modelId":@(_modelId),
                    @"setId": @(_setId),
                    @"setRecId":@(_setRecId)
                };
    }
    if ([self.getAppSubtitleTypeListAPI isEqual:manager]) {
        return @{
            @"modelId": @(_modelId)
        };
    }
    if ([self.getQuestionListAPI isEqual:manager]) {
           return @{@"functionTypeId":@(_functionTypeId),
                    @"modelId":@(_modelId),
                    @"setId": @(_setId)
                    };
       }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getQuestionListAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSDictionary *info = [data objectForKey:@"data"];
            BLTopicPaperModel *paperModel = [BLTopicPaperModel yy_modelWithJSON:info];
            _paperModel = paperModel;
            paperModel.setId = _setId;
            paperModel.modelId = _modelId;
            paperModel.functionTypeId = _functionTypeId;
            paperModel.topicTitle = _topicTitle;
            [paperModel dataProcessing];
            if (_model) {
                _model.isManual = _paperModel.isManual;
            }
        }
    }
    if ([self.getMySummaryAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            BLAnswerReportModel *model = [BLAnswerReportModel yy_modelWithJSON:[data objectForKey:@"data"]];
            _model = model;
            model.isManual = _paperModel.isManual;
            NSMutableArray *items = [NSMutableArray array];
            [items addObjectsFromArray:@[({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLAnswerReportTopTableViewCell";
                rowModel.cellHeight = 225;
                rowModel.data = model;
                rowModel;
             }),
            ({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLAnswerReportSpaceTableViewCell";
                rowModel.cellHeight = 20;
                rowModel;
            }),
            
            ({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLAnswerReportListTableViewCell";
                rowModel.cellHeight = 30;
                rowModel.data = @{
                                  @"leftTitle":@"题型",
                                  @"centerTitle":@"用时",
                                  @"rightTitle":@"正确率"
                                  };
                rowModel;
            })]];
            
            [model.cassfierDTOList enumerateObjectsUsingBlock:^(BLAnswerReportCassfierModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [items addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLAnswerReportListTableViewCell";
                    rowModel.cellHeight = 30;
                    NSString *accuracy = obj.accuracy;
                    if ([_paperModel.isManual isEqualToString:@"1"]) {
                        accuracy = @"?";
                    }
                    rowModel.data = @{
                        @"leftTitle":obj.cassfierTitle?obj.cassfierTitle:@"",
                        @"centerTitle":obj.time?obj.time:@"",
                        @"rightTitle":accuracy?accuracy:@""
                    };
                    rowModel;
                })];
            }];
            
            [items addObjectsFromArray:@[({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLAnswerReportClassificationTableViewCell";
                rowModel.cellHeight = 80;
                rowModel.delegate = self;
                rowModel.data = _model;
                rowModel;
            }),
                                         ({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLAnswerReportBottomRoundedCornersTableViewCell";
                rowModel.cellHeight = 15;
                rowModel;
            })]];
            self.sectionModel.items = items;
            [self.manager reloadData];
        }
    }
    if ([self.getAppSubtitleTypeListAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray *list = [NSArray yy_modelArrayWithClass:[BLAnswerReportQuestionListModel class] json:[data objectForKey:@"data"]];
            _itemList = list;
            self.listHeaderRowModel.data = _itemList;
            if (_itemList.count > 0) {
                BLAnswerReportQuestionListModel *model = [list firstObject];
                [self selectTypeWithModel:model];
            }
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (void)leftEvent {
    BLAnswerSheetViewController *subViewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLAnswerSheetViewController"];
    subViewController.sectionTopicList = _paperModel.sectionTopicList;
    subViewController.setId = _setId;
    subViewController.modelId = _modelId;
    subViewController.functionTypeId = _functionTypeId;
    subViewController.isFinish = YES;
    subViewController.topicTitle = _topicTitle;
    subViewController.paperModel = _paperModel;
    [self.navigationController pushViewController:subViewController animated:YES];
}

- (void)rightEvent {
    BLTopicViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
    viewController.setId = _setId;
    viewController.modelId = _modelId;
    viewController.functionTypeId = _functionTypeId;
    viewController.analysisTopicList = _paperModel.questionDTOS;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)centerEvent {
    NSMutableArray *wrongLsit = [NSMutableArray array];
    [_paperModel.questionDTOS enumerateObjectsUsingBlock:^(BLTopicModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.materialType isEqualToString:@"1"]) {
            NSMutableArray *errorList = [NSMutableArray array];
            [obj.questionList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull subObj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![subObj.isCorrect isEqualToString:@"1"]) {
                    [errorList addObject:subObj];
                }
            }];
            obj.errorQuestionList = errorList;
            if (errorList.count > 0) {
                [wrongLsit addObject:obj];
            }
        }else {
            if (![obj.isCorrect isEqualToString:@"1"]) {
                [wrongLsit addObject:obj];
            }
        }
    }];
    
    if (wrongLsit.count == 0) {
        [LCProgressHUD show:@"您全做对了，没有错题"];
        return;
    }
    
    BLTopicViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
    viewController.setId = _setId;
    viewController.modelId = _modelId;
    viewController.functionTypeId = _functionTypeId;
    viewController.analysisTopicList = wrongLsit;
    viewController.isError = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (ZLTableViewSectionModel *)footerSectionModels {
    if (!_footerSectionModels) {
        _footerSectionModels = ({
            ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
            sectionModel.headerHeight = 10;
            sectionModel.headerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
            sectionModel.items = self.footerItems;
            sectionModel;
        });
    }
    return _footerSectionModels;
}

- (NSMutableArray *)footerItems {
    if (!_footerItems) {
        _footerItems = [NSMutableArray array];
    }
    return _footerItems;
}

- (BLGetMySummaryAPI *)getMySummaryAPI {
    if (!_getMySummaryAPI) {
        _getMySummaryAPI = [[BLGetMySummaryAPI alloc] init];
        _getMySummaryAPI.paramSource = self;
        _getMySummaryAPI.mj_delegate = self;
    }
    return _getMySummaryAPI;
}

- (ZLTableViewSectionModel *)sectionModel {
    if (!_sectionModel) {
        _sectionModel = [ZLTableViewSectionModel new];
    }
    return _sectionModel;
}

- (BLGetAppSubtitleTypeListAPI *)getAppSubtitleTypeListAPI {
    if (!_getAppSubtitleTypeListAPI) {
        _getAppSubtitleTypeListAPI = [[BLGetAppSubtitleTypeListAPI alloc] init];
        _getAppSubtitleTypeListAPI.paramSource = self;
        _getAppSubtitleTypeListAPI.mj_delegate = self;
    }
    return _getAppSubtitleTypeListAPI;
}

- (BLGetQuestionListAPI *)getQuestionListAPI {
    if (!_getQuestionListAPI) {
        _getQuestionListAPI = [[BLGetQuestionListAPI alloc] init];
        _getQuestionListAPI.mj_delegate = self;
        _getQuestionListAPI.paramSource = self;
    }
    return _getQuestionListAPI;
}


@end
