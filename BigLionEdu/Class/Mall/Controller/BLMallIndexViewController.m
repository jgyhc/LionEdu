//
//  OCExampleViewController.m
//  JXPagingView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "BLMallIndexViewController.h"
#import "JXPagerView.h"
#import "JXCategoryView.h"
#import "PagingViewTableHeaderView.h"
#import "TestListBaseView.h"
#import "AdaptScreenHelp.h"
#import "BLModuleSingleton.h"
#import "BLGetGoodsTypeAPI.h"
#import "BLGetCartNumAPI.h"
#import "BLMallSearchController.h"
#import "BLMallScreeningViewController.h"
#import "BLGetGoodsAPI.h"
#import "NTCatergory.h"
#import <Masonry.h>
#import <MJRefresh.h>
#import "ZLUserInstance.h"

static const CGFloat JXTableHeaderViewHeight = 160;
static const CGFloat JXheightForHeaderInSection = 50;

@interface BLMallIndexViewController () <JXPagerViewDelegate, JXCategoryViewDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource, BLMallScreeningViewControllerDelegate>
@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) PagingViewTableHeaderView *userHeaderView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UILabel *cartNumLab;
@property (nonatomic, strong) BLGetGoodsTypeAPI * getGoodsTypeAPI;
@property (nonatomic, strong) BLGetCartNumAPI *getCartNumAPI;
@property (nonatomic, strong) NSArray * list;
@property (nonatomic, strong) BLMallScreeningViewController *screeningController;
@property (nonatomic, strong) TestListBaseView *currentList;

@property (nonatomic, strong) UIScrollView *scrollView;
//搜索
//0：书籍1：试卷2：直播3：套卷(套卷都不显示）4:录播
//labelId 折扣类型
//modelId 模块id
@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *labelId;

@end

@implementation BLMallIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCurrentList) name:@"Mall_reset_refresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToIndex:) name:@"TO_MALL" object:nil];
    [self.view setBackgroundColor:[UIColor nt_colorWithHexString:@"#F2F5F5"]];
    self.title = @"商城";
    [self.getGoodsTypeAPI loadData];
    self.cartNumLab.hidden = YES;
    _userHeaderView = [[PagingViewTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXTableHeaderViewHeight)];
    _userHeaderView.clipsToBounds = NO;
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXheightForHeaderInSection)];
//    self.categoryView.titles = self.titles;
    self.categoryView.cellSpacing = 40;
    self.categoryView.backgroundColor = [UIColor nt_colorWithHexString:@"#F2F5F5"];
    self.categoryView.delegate = self;
    self.categoryView.titleFont = [UIFont systemFontOfSize:16];
    self.categoryView.titleSelectedColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0];
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXheightForHeaderInSection) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXheightForHeaderInSection);
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.categoryView.layer.mask = maskLayer;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    
    _pagingView = [[JXPagerView alloc] initWithDelegate:self];
    _pagingView.backgroundColor = [UIColor nt_colorWithHexString:@"#F2F5F5"];
    [self.view addSubview:self.pagingView];
    
    self.categoryView.contentScrollView = self.pagingView.listContainerView.collectionView;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view insertSubview:self.navView atIndex:1000];
    [self.view insertSubview:self.topBtn atIndex:1001];
    [self.view insertSubview:self.cartBtn atIndex:1002];
    [self.view insertSubview:self.cartNumLab atIndex:1003];
    self.searchBtn.userInteractionEnabled = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.searchBtn);
        make.center.equalTo(self.searchBtn);
    }];
    [button addTarget:self action:@selector(lb_toSearch:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)scrollToIndex:(NSNotification *)notification {
    NSNumber *number = notification.object;
    [self.categoryView selectItemAtIndex:number.integerValue + 1];
}

- (void)lb_toSearch:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        BLMallSearchController *controller = [BLMallSearchController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    });
}

- (void)refreshCurrentList {
    self.labelId = @"";
    self.type = @"";
    self.pagingView.needResetTableViewOffset = YES;
    [self.categoryView selectItemAtIndex:0];
    [self.scrollView setContentOffset:CGPointMake(0, NavigationHeight()) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pagingView.needResetTableViewOffset = NO;
        self.currentList.type = @"";
        self.currentList.labelId = @"";
        [self.currentList bl_refresh];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagingView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ZLUserInstance sharedInstance].token.length > 0) {
        [self.getCartNumAPI loadData];
    }
}

#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return JXTableHeaderViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return JXheightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    TestListBaseView *list = [[TestListBaseView alloc] init];
    list.viewController = self;
    _currentList = list;
    list.type = self.type;
    list.labelId = self.labelId;
    NSDictionary *dic = _list[index];
    list.modelId = [dic objectForKey:@"id"];
    self.modelId = [dic objectForKey:@"id"];
    return list;
}


- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    self.scrollView = scrollView;
    if (scrollView.contentOffset.y <= 0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
        [_currentList.collectionView.mj_header beginRefreshing];
    }
//    [self.userHeaderView scrollViewDidScroll:scrollView.contentOffset.y];
}

- (IBAction)handlerScreenEvent:(id)sender {
    NSDictionary *dic = _list[self.categoryView.selectedIndex];
    self.modelId = [dic objectForKey:@"id"];
    _screeningController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallScreeningViewController"];
    _screeningController.modelId = self.modelId;
    _screeningController.delegate = self;
    _screeningController.currentType = self.type;
    _screeningController.currentDisType = self.labelId;
    [self presentViewController:_screeningController animated:YES completion:nil];
}

- (void)BLMallScreeningViewController:(NSString *)labelId type:(NSString *)type {
    self.labelId = labelId;
    self.type = type;
    self.currentList.labelId = labelId;
    self.currentList.type = type;
    [self.currentList bl_refresh];
}

- (void)currentList:(TestListBaseView *)currentView {
    _currentList = currentView;
    if (![_currentList.type isEqualToString:self.type] || ![_currentList.labelId isEqualToString:self.labelId]) {
        _currentList.labelId = self.labelId;
        _currentList.type = self.type;
        [_currentList bl_refresh];
    }
}

- (IBAction)bl_toTop:(id)sender {
    [_currentList.collectionView setContentOffset:CGPointZero];
}

- (IBAction)bl_toShoppingCart:(id)sender {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLShoppingCartViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getGoodsTypeAPI isEqual:manager]) {
        return nil;
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getGoodsTypeAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray *list = [data objectForKey:@"data"];
            _list = list;
            NSMutableArray *titles = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [titles addObject:[obj objectForKey:@"title"]];
            }];
            self.titles = titles;
            self.categoryView.titles = self.titles;
            [self.categoryView reloadData];
            [self.pagingView reloadData];
        }
    } else if ([self.getCartNumAPI isEqual:manager]) {
        NSInteger number = [data[@"data"] integerValue];
        if (number <= 0) {
            self.cartNumLab.hidden = YES;
        } else {
            self.cartNumLab.hidden = NO;
            self.cartNumLab.text = [NSString stringWithFormat:@"%ld", (long)number];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (BLGetGoodsTypeAPI *)getGoodsTypeAPI {
    if (!_getGoodsTypeAPI) {
        _getGoodsTypeAPI = [[BLGetGoodsTypeAPI alloc] init];
        _getGoodsTypeAPI.mj_delegate = self;
        _getGoodsTypeAPI.paramSource = self;
    }
    return _getGoodsTypeAPI;
}

- (BLGetCartNumAPI *)getCartNumAPI {
    if (!_getCartNumAPI) {
        _getCartNumAPI = [[BLGetCartNumAPI alloc] init];
        _getCartNumAPI.mj_delegate = self;
        _getCartNumAPI.paramSource = self;
    }
    return _getCartNumAPI;
}

@end


