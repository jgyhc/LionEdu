//
//  BLTrainSearchResultViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/6.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainSearchResultViewController.h"
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
#import "BLTrainSearchItemTableViewController.h"

@interface BLTrainSearchResultViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (nonatomic, strong) JXCategoryListContainerView *categoryListContainerView;
@property (weak, nonatomic) IBOutlet UILabel *searchKeyLabel;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryTitleView;


@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) BLGetBaseTypeByIdTypeAPI * getBaseTypeByIdTypeAPI;
@end

@implementation BLTrainSearchResultViewController


- (IBAction)backEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.getBaseTypeByIdTypeAPI loadData];
    _categoryTitleView.titleColor = [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
    _categoryTitleView.titleSelectedColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
//    [_categoryTitleView setBackgroundColor:[UIColor whiteColor]];
    self.categoryTitleView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
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
    _searchKeyLabel.text = _key;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //处于第一个item的时候，才允许屏幕边缘手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryTitleView.selectedIndex == 0);
}

- (IBAction)screeningEvent:(id)sender {
    BLQuestionScreeningViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLQuestionScreeningViewController"];
    [viewController setDidSelectScreenHanlder:^(NSDictionary * _Nonnull params) {
        NSLog(@"%@", params);
    }];
    viewController.modalPresentationStyle = 0;
    [self presentViewController:viewController animated:NO completion:nil];
}

- (IBAction)searchEvent:(id)sender {
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
                 @"functionType": @(1)
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
//            if (_type == 1) {
//                [list enumerateObjectsUsingBlock:^(BLQuestionsClassificationModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([obj.isTest isEqualToString:@"1"]) {
//                        [self.categoryTitleView selectItemAtIndex:idx];
//                        *stop = YES;
//                    }
//                }];
//            }
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
    BLTrainSearchItemTableViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainSearchItemTableViewController"];
    viewController.modelId = _modelId;
    viewController.searchTitle = _key;
    viewController.functionTypeId = model.Id;
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
