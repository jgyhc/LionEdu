//
//  BLQuestionBankViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLQuestionBankViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryIndicatorLineView.h"
#import <Masonry.h>
#import "BLQuestionsClassificationModel.h"
#import <YYModel.h>
#import "BLGetBaseTypeByIdTypeAPI.h"
#import "BLQuestionBankTableViewController.h"
#import "BLQuestionScreeningViewController.h"
#import "BLQuestionBankMockViewController.h"
#import "BLMallSearchController.h"
#import "NTCatergory.h"

@interface BLQuestionBankViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (nonatomic, strong) JXCategoryListContainerView *categoryListContainerView;

@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryTitleView;

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) BLGetBaseTypeByIdTypeAPI * getBaseTypeByIdTypeAPI;

@end

@implementation BLQuestionBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.getBaseTypeByIdTypeAPI loadData];
    _categoryTitleView.titleColor = [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
    _categoryTitleView.titleSelectedColor = [UIColor nt_colorWithHexString:@"#FF6B00"];
    [_categoryTitleView setBackgroundColor:[UIColor whiteColor]];
    self.categoryTitleView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    lineView.indicatorLineViewColor = [UIColor nt_colorWithHexString:@"#FF6B00"];
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //处于第一个item的时候，才允许屏幕边缘手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryTitleView.selectedIndex == 0);
}

- (IBAction)screeningEvent:(id)sender {
    BLQuestionScreeningViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLQuestionScreeningViewController"];
    __weak typeof(self) wself = self;
    [viewController setDidSelectScreenHanlder:^(NSDictionary * _Nonnull params) {
        NSDictionary *intervalYear = [params objectForKey:@"intervalYear"];
        NSString *startYear = [intervalYear objectForKey:@"startYear"];
        NSString *endYear = [intervalYear objectForKey:@"endYear"];
        NSString *province = [params objectForKey:@"province"];
        NSString *city = [params objectForKey:@"city"];
        NSString *area = [params objectForKey:@"area"];
        NSArray *years = [params objectForKey:@"years"];
        [wself.categoryListContainerView.validListDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, id<JXCategoryListContentViewDelegate>  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[BLQuestionBankTableViewController class]]) {
                BLQuestionBankTableViewController *viewController = (BLQuestionBankTableViewController *)obj;
                viewController.startYears = startYear;
                viewController.endYears = endYear;
                viewController.province = province;
                viewController.city = city;
                viewController.area = area;
                viewController.years = [years componentsJoinedByString:@","];
                [viewController reloadData];
            }
        }];
    }];
    [self presentViewController:viewController animated:NO completion:nil];
}

- (IBAction)searchEvent:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        BLMallSearchController *controller = [BLMallSearchController new];
        controller.type = 1;
        controller.modelId = self.modelId;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getBaseTypeByIdTypeAPI isEqual:manager]) {
        return @{@"modelId": @(_modelId),
                 @"functionType": @1
                 };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getBaseTypeByIdTypeAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray *list = [NSArray yy_modelArrayWithClass:[BLQuestionsClassificationModel class] json:[data objectForKey:@"data"]];
            self.datas = list;
            NSMutableArray *titles = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(BLQuestionsClassificationModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [titles addObject:obj.title];
            }];
            self.categoryTitleView.titles = titles;
            [self.categoryTitleView reloadData];
            [self.categoryListContainerView reloadData];
            if (_type == 1) {
                [list enumerateObjectsUsingBlock:^(BLQuestionsClassificationModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.isTest isEqualToString:@"1"]) {
                        [self.categoryTitleView selectItemAtIndex:idx];
                        [self.categoryListContainerView didClickSelectedItemAtIndex:idx];
                        *stop = YES;
                    }
                }];
            }
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
    BLQuestionsClassificationModel *model = self.datas[index];
    if ([model.isTest isEqualToString:@"1"]) {
        BLQuestionBankMockViewController *mockViewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLQuestionBankMockViewController"];
        mockViewController.modelId = _modelId;
        mockViewController.functionTypeId = model.Id;
        mockViewController.superViewController = self;
        return mockViewController;
    }
    
    BLQuestionBankTableViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLQuestionBankTableViewController"];
    viewController.superViewController = self;
    viewController.modelId = _modelId;
    viewController.parentId = model.Id;
    return viewController;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.datas.count;
}

- (BLGetBaseTypeByIdTypeAPI *)getBaseTypeByIdTypeAPI {
    if (!_getBaseTypeByIdTypeAPI) {
        _getBaseTypeByIdTypeAPI = [[BLGetBaseTypeByIdTypeAPI alloc] init];
        _getBaseTypeByIdTypeAPI.mj_delegate = self;
        _getBaseTypeByIdTypeAPI.paramSource = self;
    }
    return _getBaseTypeByIdTypeAPI;
}

@end
