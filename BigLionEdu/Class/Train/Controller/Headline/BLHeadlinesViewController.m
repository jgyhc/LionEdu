//
//  BLHeadlinesViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/12.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLHeadlinesViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryIndicatorLineView.h"
#import "BLHeadlinesItemTableViewController.h"
#import <Masonry.h>
#import "BLNewsListModel.h"
#import <YYModel.h>
#import "BLGetAppTypeNewsAPI.h"
#import "NTCatergory.h"


@interface BLHeadlinesViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (nonatomic, strong) JXCategoryListContainerView *categoryListContainerView;

@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryTitleView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) BLGetAppTypeNewsAPI *getAppTypeNewsAPI;

@property (nonatomic, strong) NSArray<BLNewsListModel *> *models;

@end

@implementation BLHeadlinesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _categoryTitleView.titleColor = [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
    _categoryTitleView.titleSelectedColor = [UIColor nt_colorWithHexString:@"#333333"];
    _categoryTitleView.titleSelectedFont = [UIFont boldSystemFontOfSize:16];
    _categoryTitleView.titleLabelZoomEnabled = YES;
    [_categoryTitleView setBackgroundColor:[UIColor whiteColor]];
//    _categoryTitleView.cellSpacing = 30;
//    _categoryTitleView.contentEdgeInsetLeft = 15;
//    _categoryTitleView.contentEdgeInsetRight = 15;
    self.categoryTitleView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    lineView.indicatorHeight = 2;
    self.categoryTitleView.indicators = @[lineView];
    self.categoryListContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    [self.view addSubview:self.categoryListContainerView];
    [self.categoryListContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.categoryTitleView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    self.categoryTitleView.delegate = self;
    self.categoryListContainerView.didAppearPercent = 0.01; //滚动一点就触发加载
    
    self.categoryTitleView.contentScrollView = self.categoryListContainerView.scrollView;
    [self.getAppTypeNewsAPI loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //处于第一个item的时候，才允许屏幕边缘手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryTitleView.selectedIndex == 0);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index {
    BLHeadlinesItemTableViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLHeadlinesItemTableViewController"];
    BLNewsListModel *model = _models[index];
    viewController.superViewController = self;
    viewController.typeId = model.Id;
    return viewController;
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getAppTypeNewsAPI isEqual:manager]) {
        return @{@"modelId": @(_modelId)};
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getAppTypeNewsAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            _models = [NSArray yy_modelArrayWithClass:[BLNewsListModel class] json:[data objectForKey:@"data"]];
            NSMutableArray *list = [NSMutableArray array];
            [_models enumerateObjectsUsingBlock:^(BLNewsListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [list addObject:obj.title?obj.title:@""];
            }];
            self.titles = list;
            self.categoryTitleView.titles = _titles;
            [self.categoryTitleView reloadData];
            [self.categoryListContainerView reloadData];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.categoryListContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.categoryListContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<JXCategoryListContentViewDelegate> list = [self preferredListAtIndex:index];
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.models.count;
}

- (BLGetAppTypeNewsAPI *)getAppTypeNewsAPI {
    if (!_getAppTypeNewsAPI) {
        _getAppTypeNewsAPI = [[BLGetAppTypeNewsAPI alloc] init];
        _getAppTypeNewsAPI.paramSource = self;
        _getAppTypeNewsAPI.mj_delegate = self;
    }
    return _getAppTypeNewsAPI;
}

@end
