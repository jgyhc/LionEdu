//
//  BLMockDetailViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLMockDetailViewController.h"
#import "ZLTableViewDelegateManager.h"
#import <YYModel.h>
#import "BLSignUpTestAPI.h"
#import <LCProgressHUD.h>
#import "BLMockDetailTopTableViewCell.h"
#import "BLMockDetailButtonTableViewCell.h"
#import "BLTopicViewController.h"
#import "ZLUserInstance.h"
#import <LCProgressHUD.h>

@interface BLMockDetailViewController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource, BLMockDetailTopTableViewCellDelegate, BLMockDetailButtonTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;

@property (nonatomic, strong) ZLTableViewSectionModel *topSectionModel;

@property (nonatomic, strong) ZLTableViewSectionModel *bottomSectionModel;

@property (nonatomic, strong) BLSignUpTestAPI * signUpTestAPI;
@end

@implementation BLMockDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

- (void)initData {
//    _model.status = @"2";
//    _model.startDateLog = 1569658787000;
//    _model.endDateLog = 1569673187000;
//    _model.countdown = 120;
    [_model getCurrentDateState];
    NSMutableArray *items = [NSMutableArray array];
    self.topSectionModel.items = items;
    [items addObject:({
        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
        rowModel.identifier = @"BLMockDetailTopTableViewCell";
        rowModel.data = _model;
        rowModel.delegate = self;
        rowModel.cellHeight = 179;
        rowModel;
    })];
    //status    string    模考状态：1.未报名、2、已报名、3、已考试
    if ([_model.status isEqualToString:@"2"]) {
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLMockDetailButtonTableViewCell";
            rowModel.data = _model;
            rowModel.cellHeight = 60;
            rowModel.delegate = self;
            rowModel;
        })];
    }
    self.bottomSectionModel.items = @[
        ({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLMockDetailContentTableViewCell";
            rowModel.data = @{
                @"title": @"考试时间",
                @"content": _model.timeString?_model.timeString:@""
            };
            rowModel.cellHeight = -1;
            rowModel;
        }),
        ({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLMockDetailParsingTableViewCell";
            rowModel.data = _model;
            rowModel.cellHeight = 140;
            rowModel;
        }),
        ({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLMockDetailContentTableViewCell";
            rowModel.data = @{
                @"title": @"考试说明",
                @"content": _model.testRule?_model.testRule:@""
            };
            rowModel.cellHeight = -1;
            rowModel;
        })
    ];
    [self.manager reloadData];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[self.topSectionModel, self.bottomSectionModel];
}

#pragma mark -- BLMockDetailButtonTableViewCellDelegate method
- (void)didSelectButtonWithModel:(BLMockItemModel *)model {
    /** 模考状态：1.未报名、2、已报名、3、已考试 */
    ////0未到提醒时间  1 到了提醒时间了  2 已经开始了
    if ([model.status isEqualToString:@"2"] && model.timeStatus == 2) {
        //立即考试
        if (![ZLUserInstance sharedInstance].isLogin) {
            [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
            return;
        }
        BLTopicViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
        viewController.setId = model.setId;
        viewController.modelId = _modelId;
        viewController.functionTypeId = _functionTypeId;
        viewController.topicTitle = model.title;
        viewController.duration = [model.duration integerValue];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark -- BLMockDetailTopTableViewCellDelegate method
- (void)signUpWithModel:(BLMockItemModel *)model {
    if (_model.isCanSignUp) {
        [self.signUpTestAPI loadData];
    }else {
        [LCProgressHUD show:@"报名已结束"];
    }
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.signUpTestAPI isEqual:manager]) {
        return @{@"testId": @(_model.testId)};
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.signUpTestAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [LCProgressHUD show:@"报名成功"];
            _model.status = @"2";
            [self initData];
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

- (ZLTableViewSectionModel *)topSectionModel {
    if (!_topSectionModel) {
        _topSectionModel = [ZLTableViewSectionModel new];
    }
    return _topSectionModel;
}

- (ZLTableViewSectionModel *)bottomSectionModel {
    if (!_bottomSectionModel) {
        _bottomSectionModel = [ZLTableViewSectionModel new];
        _bottomSectionModel.headerHeight = 10;
        _bottomSectionModel.headerBackgroundColor = [UIColor colorWithRed:248.0/255.0 green:249.0/255.0 blue:250.0/255.0 alpha:1];
    }
    return _bottomSectionModel;
}

- (BLSignUpTestAPI *)signUpTestAPI {
    if (!_signUpTestAPI) {
        _signUpTestAPI = [[BLSignUpTestAPI alloc] init];
        _signUpTestAPI.mj_delegate = self;
        _signUpTestAPI.paramSource = self;
    }
    return _signUpTestAPI;
}

@end
