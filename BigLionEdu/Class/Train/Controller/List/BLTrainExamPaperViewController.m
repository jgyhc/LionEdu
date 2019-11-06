//
//  BLTrainExamPaperViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainExamPaperViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryIndicatorLineView.h"
#import <Masonry.h>
#import "BLMyCollectModel.h"
#import <YYModel/NSObject+YYModel.h>
#import "BLTrainListVideoTableViewController.h"
#import "BLBaseCurriculumModel.h"
#import "BLGetBaseTypeByIdTypeAPI.h"
#import "BLQuestionsClassificationModel.h"
#import "BLTrainExamPaperTableViewController.h"


@interface BLTrainExamPaperViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate,CTAPIManagerParamSource, MJAPIBaseManagerDelegate>

@property (nonatomic, strong) JXCategoryListContainerView *categoryListContainerView;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryTitleView;
@property (nonatomic, strong) BLGetBaseTypeByIdTypeAPI * getBaseTypeByIdTypeAPI;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation BLTrainExamPaperViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.categoryTitleView.titles = self.titles;
    [self setSubViews];
    [self.getBaseTypeByIdTypeAPI loadData];
}

//- (void)setFunctionTypeDTOList:(NSArray *)functionTypeDTOList {
//    _functionTypeDTOList = functionTypeDTOList;
//    _titleModels = [NSArray yy_modelArrayWithClass:[BLBaseCurriculumModel class] json:functionTypeDTOList];
//}

- (UIView *)listView {
    return self.view;
}

#pragma mark view

- (void)setSubViews{
    _categoryTitleView.titleColor = [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
    _categoryTitleView.titleSelectedColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    _categoryTitleView.titleColorGradientEnabled = YES;
    [_categoryTitleView setBackgroundColor:[UIColor whiteColor]];
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
//    NSMutableArray *titles = [NSMutableArray array];
//    [_titleModels enumerateObjectsUsingBlock:^(BLBaseCurriculumModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSString *title = obj.title;
//        [titles addObject:title?title:@""];
//    }];
//    self.categoryTitleView.titles = titles;
//    [self.categoryTitleView reloadData];
//    [self.categoryListContainerView reloadData];
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
    BLQuestionsClassificationModel *model = _datas[index];
    BLTrainExamPaperTableViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainExamPaperTableViewController"];
    viewController.functionTypeId = model.Id;
    viewController.modelId = model.modelId;
    viewController.type = [model.type integerValue];
    return viewController;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.datas.count;
}


#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getBaseTypeByIdTypeAPI isEqual:manager]) {
        return @{@"modelId":@(_modelId),
                 @"functionType":@(3),
                 @"parentId":@(_parentId)
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
        }
    }
}


- (void)failManager:(CTAPIBaseManager *)manager {
    
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
