//
//  BLVideoClassDetailViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLVideoClassDetailViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "AdaptScreenHelp.h"
#import "UIViewController+ZLCustomNavigationBar.h"
#import "BLGetCurriculumDetailAPI.h"
#import "BLClassDetailModel.h"
#import <YYModel.h>
#import "BLClassWebTableViewCell.h"
#import "BLAddGoodsCartAPI.h"
#import "BLClassMenuTableViewCell.h"
#import "BLClassMenuHeaderView.h"
#import "BLTrainVideoViewController.h"
#import "BLVideoShareInfoManager.h"
#import "NTCatergory.h"
#import "BLClassDetailNav.h"
#import <Masonry.h>
#import "AdaptScreenHelp.h"
#import "BLPaperBuyAlertViewController.h"
#import "BLMallOrderSureViewController.h"

@interface BLVideoClassDetailViewController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource, BLClassWebTableViewCellDelegate, BLClassMenuTableViewCellDelegate, BLClassMenuHeaderViewDelegate, BLClassDetailNavDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) BLGetCurriculumDetailAPI *getCurriculumDetailAPI;
@property (weak, nonatomic) IBOutlet UIButton *shoppingCartButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (nonatomic, strong) NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomSpace;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) BLClassDetailModel *model;
@property (nonatomic, strong) BLAddGoodsCartAPI *addGoodsCartAPI;
@property (nonatomic, strong) NSIndexPath *catalogueIndexPath;//目录的位置
@property (nonatomic, strong) NSIndexPath *webIndexPath;//图文详情的位置
@property (nonatomic, strong) BLClassDetailNav *nav;
@property (nonatomic, assign) NSInteger webViewHeight;

@property (nonatomic, assign) BOOL isDetail;
@property (nonatomic, assign) BOOL isList;

@end

@implementation BLVideoClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.tableView registerClass:NSClassFromString(@"BLClassMenuHeaderView") forHeaderFooterViewReuseIdentifier:@"BLClassMenuHeaderView"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
//    [self.tableView registerClass:NSClassFromString(@"BLClassMenuHeaderView") forCellReuseIdentifier:@"BLClassMenuHeaderView"];
    self.webViewHeight = 80;
    [self.manager reloadData];
    [self.getCurriculumDetailAPI loadData];
    
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.nav = [BLClassDetailNav new];
    self.nav.delegate = self;
    [self.view addSubview:self.nav];
    [self.nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(NavigationHeight() + 40);
    }];
    self.nav.hidden = YES;
}

- (void)viewDetailHandler {
    self.isDetail = YES;
    CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.datas.count - 1]];
    [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - NavigationHeight() - 40) animated:YES];
}

- (void)catalogueHandler {
    self.isList = YES;
    CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:self.datas.count - 1]];
    [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - NavigationHeight() - 40) animated:YES];
}

- (void)backHandler {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView manager:(ZLTableViewDelegateManager *)manager {
    CGRect rect = [self.tableView rectForHeaderInSection:1];
    CGFloat offset = rect.origin.y - scrollView.contentOffset.y;
    if (offset <= NavigationHeight()) {
        self.nav.hidden = NO;
    } else {
        self.nav.hidden = YES;
    }
    CGFloat y = scrollView.contentOffset.y - 10;
    NSIndexPath *index = [self.tableView indexPathForRowAtPoint:CGPointMake(0, y)];
    if (index.section == 1 && index.row == 0) {
        if (self.isList) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.isList = false;
            });
            return;
        }
        [self.nav moveSlider:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VC_TO_DETAIL" object:nil];
    } else if (index.section == 1 && index.row > 0) {
        if (self.isDetail) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.isDetail = false;
            });
            return;
        }
        [self.nav moveSlider:2];
    }
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return self.datas;
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLClassCatalogueGroupTableViewCell"]) {
        BLClassScheduleModel *data = model.data;
        data.isOpen = !data.isOpen;
        [self relaodData];
    } else if ([model.identifier isEqualToString:@"BLClassCatalogueItemTableViewCell"]) {
        NSArray *datas = model.data;
        BLClassScheduleItemModel *obj = datas.firstObject;
        if ([self.model.isPurchase isEqualToString:@"1"] || [self.model.isFree isEqualToString:@"1"]) {
            BLTrainVideoViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainVideoViewController"];
            viewController.model = obj;
            viewController.detailModel = self.model;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            [self buy];
        }
    }
}

- (void)buy {
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
    BLPaperBuyAlertViewController *viewController =
       [[BLPaperBuyAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                                content:@"立即购买全部课程"
                                                buttons:buttons tapBlock:^(BLPaperBuyAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
           if ([title isEqualToString:@"立即购买"]) {
               BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
               BLPaperModel *pModel = [BLPaperModel new];
               pModel.goodsId = self.model.Id;
               pModel.price = self.model.price;
               pModel.coverImg = self.model.coverImg;
               pModel.title = self.model.title;
               viewController.paperModel = pModel;
               viewController.backToController = @"BLVideoClassDetailViewController";
               [self.navigationController pushViewController:viewController animated:YES];
           }
           }];
    viewController.textAlignment = NSTextAlignmentCenter;
    viewController.priceString = [NSString stringWithFormat:@"￥%0.2f/套", [self.model.price doubleValue]];
    viewController.modalPresentationStyle = 0;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)cellInitializeWithModel:(ZLTableViewRowModel *)model cell:(UITableViewCell *)cell manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLClassCatalogueHeaderTableViewCell"]) {
        _catalogueIndexPath = indexPath;
    }
    if ([model.identifier isEqualToString:@"BLClassWebTableViewCell"]) {
        _webIndexPath = indexPath;
    }
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getCurriculumDetailAPI isEqual:manager]) {
        return @{@"recId": @(_recId),
                 @"type": @(4)
        };
    }
    if ([self.addGoodsCartAPI isEqual:manager]) {
        return @{@"goodsId": @(_model.goodsId),
                 @"goodsNum":@1,
                 @"cartPrice": _model.price
        };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getCurriculumDetailAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            _model = [BLClassDetailModel yy_modelWithJSON:[data objectForKey:@"data"]];
            if ([_model.isFree isEqualToString:@"1"] && _model.price.floatValue <= 0) {
                self.bottomView.hidden = YES;
                _tableViewBottomSpace.constant = 0;
            } else if ([_model.isPurchase isEqualToString:@"1"]) {
                self.bottomView.hidden = YES;
                _tableViewBottomSpace.constant = 0;
            } else {
                self.bottomView.hidden = NO;
                _tableViewBottomSpace.constant = 50;
            }
            [self.buyButton setTitle:[NSString stringWithFormat:@"购买：￥%0.2f", [_model.price doubleValue]] forState:UIControlStateNormal];
            [self.view layoutIfNeeded];
            [self relaodData];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (IBAction)intoShoppingCartEvent:(id)sender {
    [self.addGoodsCartAPI loadData];
}

- (IBAction)buyEvent:(id)sender {
    BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
    if (self.goodsId > 0) {
        viewController.goodsId = @(self.goodsId).stringValue;
    } else {
        viewController.goodsId = @(self.model.goodsId).stringValue;
    }
    viewController.groupId = @"";
    //拼团类型：0：单独购买，1：发起拼团，2：参加拼团
    viewController.groupType = @0;
    viewController.backToController = @"BLVideoClassDetailViewController";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)backEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareEvent:(id)sender {
    [[CTMediator sharedInstance] performTarget:@"share" action:@"mjshare" params:@{
    @"sid":@"",
    @"shareEventCallbackUrl":@"",
    @"generalOptions": @{
            @"describe": @"别身在福中不知福 ​​​​",
            @"img": @"https://wx3.sinaimg.cn/mw690/67dd74e0gy1g5lpdxwtz5j20u00u0ajl.jpg",
            @"linkurl": @"https://weibo.com/u/3223229794/home?wvr=5#1564759631081",
            @"title": @"别身在福中不知福 ​​​​"
            }
    } shouldCacheTarget:YES];
}


#pragma mark -- BLClassMenuHeaderViewDelegate
- (void)updateButtonClick:(NSInteger)index {
    if (index == 0) {
        self.isDetail = YES;
        [self.nav moveSlider:1];
        [self.tableView scrollToRowAtIndexPath:_webIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
    if (index == 1) {
        self.isList = YES;
        [self.nav moveSlider:2];
        [self.tableView scrollToRowAtIndexPath:_catalogueIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)relaodData {
    [self.datas removeAllObjects];
    [BLVideoShareInfoManager shared].videoName = self.model.title;
    [BLVideoShareInfoManager shared].onlinenumber = @"200";
    [BLVideoShareInfoManager shared].avatar = self.model.tutorDTOS.firstObject.headImg;
    [BLVideoShareInfoManager shared].name = self.model.tutorDTOS.firstObject.name;
    [BLVideoShareInfoManager shared].desc = self.model.tutorDTOS.firstObject.tutorTitle;
    
    [self.datas addObject:({
        ZLTableViewSectionModel *topSectionModel = [ZLTableViewSectionModel new];
        topSectionModel.footerHeight = 10.0;
        topSectionModel.footerBackgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
        NSMutableArray *items = [NSMutableArray array];
        topSectionModel.items = items;
        [items addObjectsFromArray:@[({
             ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
             rowModel.identifier = @"BLClassBannerTableViewCell";
             rowModel.cellHeight = 250 + StatusBarHeight();
             rowModel.data = _model;
             rowModel;
         }),
        ({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLIntroductionClassTableViewCell";
            rowModel.cellHeight = 142;
            rowModel.data = _model;
            rowModel;
        }),
        
        ]];
        topSectionModel;
    })];
    
    [self.datas addObject:({
        ZLTableViewSectionModel *topSectionModel = [ZLTableViewSectionModel new];
        topSectionModel.headerHeight = 50;
        topSectionModel.headerIdentifier = @"BLClassMenuHeaderView";
        topSectionModel.headerDelegate = self;
        NSMutableArray *items = [NSMutableArray array];
        topSectionModel.items = items;
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLClassWebTableViewCell";
            rowModel.cellHeight = self.webViewHeight;
            rowModel.data = _model.introduce;
            rowModel.delegate = self;
            rowModel;
        })];
        if (_model.liveRecCourseTypeDTOS.count > 0) {
               [items addObject:({
                   ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                   rowModel.identifier = @"BLClassCatalogueHeaderTableViewCell";
                   rowModel.cellHeight = 30;
                   rowModel;
               })];
           }
        
        [_model.liveRecCourseTypeDTOS enumerateObjectsUsingBlock:^(BLClassScheduleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [items addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLClassCatalogueGroupTableViewCell";
                rowModel.cellHeight = 61;
                rowModel.data = obj;
                rowModel;
            })];
            if (obj.isOpen) {
                [obj.liveRecCourseDTOS enumerateObjectsUsingBlock:^(BLClassScheduleItemModel * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
                    [items addObject:({
                        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                        rowModel.identifier = @"BLClassCatalogueItemTableViewCell";
                        rowModel.cellHeight = 61;
                        rowModel.data = @[item, self.model];
                        rowModel;
                    })];
                }];
            }
        }];
        topSectionModel;
    })];

    [self.manager reloadData];
}

- (void)updateCellHeight:(CGFloat)height indexPath:(NSIndexPath *)indexPath {
    self.webViewHeight = height;
    ZLTableViewSectionModel *sectionModel = self.datas[1];
    ZLTableViewRowModel *rowModel =  sectionModel.items[0];;
    rowModel.cellHeight = height;
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.manager reloadData];
}

- (void)setWebViewHeight:(NSInteger)webViewHeight {
    _webViewHeight = webViewHeight;
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.tableView = self.tableView;
        _manager.delegate = self;
    }
    return _manager;
}

- (BLGetCurriculumDetailAPI *)getCurriculumDetailAPI {
    if (!_getCurriculumDetailAPI) {
        _getCurriculumDetailAPI = [[BLGetCurriculumDetailAPI alloc] init];
        _getCurriculumDetailAPI.mj_delegate = self;
        _getCurriculumDetailAPI.paramSource = self;
    }
    return _getCurriculumDetailAPI;
}


- (BLAddGoodsCartAPI *)addGoodsCartAPI {
    if (!_addGoodsCartAPI) {
        _addGoodsCartAPI = [[BLAddGoodsCartAPI alloc] init];
        _addGoodsCartAPI.mj_delegate = self;
        _addGoodsCartAPI.paramSource = self;
    }
    return _addGoodsCartAPI;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

@end
