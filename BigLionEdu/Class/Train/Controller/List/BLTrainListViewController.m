//
//  BLQuestionListViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainListViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryIndicatorLineView.h"
#import "BLQuestionListTableViewController.h"
#import "BLTrainListVideoTableViewController.h"
#import <Masonry.h>
#import "BLTrainShareViewController.h"
#import "BLGetBaseCurriculumTypeAPI.h"
#import <YYModel.h>
#import "BLBaseCurriculumModel.h"
#import "BLTrainRecordedViewController.h"
#import "BLInterViewController.h"
#import "BLTrainExamPaperViewController.h"
#import "BLMallSearchController.h"


@interface BLTrainListViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, CTAPIManagerParamSource, MJAPIBaseManagerDelegate>

@property (nonatomic, strong) JXCategoryListContainerView *categoryListContainerView;
@property (nonatomic, strong) JXCategoryTitleView *categoryTitleView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) BLGetBaseCurriculumTypeAPI * getBaseCurriculumTypeAPI;
@property (nonatomic, strong) NSArray<BLBaseCurriculumModel *> * list;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) BLBaseCurriculumModel *currentModel;

@end

@implementation BLTrainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.getBaseCurriculumTypeAPI loadData];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.categoryTitleView = [[JXCategoryTitleView alloc] init];
    self.categoryTitleView.frame = CGRectMake(0, 0, 275, 26);
    self.categoryTitleView.layer.cornerRadius = 3;
    self.categoryTitleView.layer.masksToBounds = YES;
    self.categoryTitleView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0].CGColor;
    self.categoryTitleView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    self.categoryTitleView.titles = self.titles;
    self.categoryTitleView.cellSpacing = 0;
    self.categoryTitleView.cellWidth = 85;
    self.categoryTitleView.backgroundColor = [UIColor whiteColor];
//    self.categoryTitleView.
    self.categoryTitleView.titleColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    self.categoryTitleView.titleSelectedColor = [UIColor whiteColor];
    self.categoryTitleView.titleLabelMaskEnabled = YES;
    
    self.navigationItem.titleView = self.categoryTitleView;
    
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = 26;
    backgroundView.indicatorWidth = JXCategoryViewAutomaticDimension;
    backgroundView.indicatorCornerRadius = 2;
//    backgroundView.indicatorWidthIncrement = 0;
//    backgroundView.backgroundViewWidthIncrement = 10;
    backgroundView.indicatorColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    self.categoryTitleView.indicators = @[backgroundView];
    self.categoryListContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    [self.view addSubview:self.categoryListContainerView];
    [self.categoryListContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.view);
    }];
    self.categoryTitleView.delegate = self;
    self.categoryListContainerView.didAppearPercent = 0.01; //滚动一点就触发加载
    self.categoryTitleView.separatorLineShowEnabled = YES;
    self.categoryTitleView.separatorLineColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    self.categoryTitleView.separatorLineSize = CGSizeMake(0.5, 26);
    self.categoryTitleView.contentScrollView = self.categoryListContainerView.scrollView;
    
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.searchBtn setImage:[UIImage imageNamed:@"tk_ss"] forState:UIControlStateNormal];
    self.searchBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.searchBtn addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];

}

- (void)toSearch {
    BLMallSearchController *controller = [BLMallSearchController new];
    controller.type = 4;
    controller.functionTypeId = @(self.currentModel.Id).stringValue;
    controller.modelId = self.currentModel.modelId;
    controller.searchType = self.currentModel.type;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
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
    BLBaseCurriculumModel *model = self.list[index];
    /**  1:题库，2：直播，3：录播，4：狮享，5：面授 */
    if (model.type == 1) {
        if (model.functionType == 3) {
            BLTrainExamPaperViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainExamPaperViewController"];
            viewController.modelId = _modelId;
            viewController.parentId = model.Id;
            return viewController;
        }else {
            BLQuestionListTableViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLQuestionListTableViewController"];
           viewController.superViewController = self;
           viewController.modelId = _modelId;
           viewController.parentId = model.parentId;
           if (model.functionTypeDTOList && model.functionTypeDTOList.count > 0) {
               viewController.list = [model.functionTypeDTOList yy_modelToJSONObject];
           }
           return viewController;
        }
        
    }
    if (model.type == 2) {
        BLTrainListVideoTableViewController *vc = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainListVideoTableViewController"];
        vc.functionTypeId = model.Id;
        vc.modelId = _modelId;
        vc.type = model.type;
        return vc;
    }
    if (model.type == 3) {
        BLTrainRecordedViewController *vc = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainRecordedViewController"];
        vc.functionTypeDTOList = [model.functionTypeDTOList yy_modelToJSONObject];
        vc.functionTypeId = model.Id;
        vc.modelId = model.modelId;
        vc.superViewController = self;
        self.currentModel = model;
        return vc;
    }
    if (model.type == 4) {
        BLTrainShareViewController *vc = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainShareViewController"];
        vc.superViewController = self;
        vc.functionTypeId = model.Id;
        vc.modelId = _modelId;
        vc.type = model.type;
        return vc;
    }
    BLQuestionListTableViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLQuestionListTableViewController"];
    viewController.superViewController = self;
    return viewController;
}



#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    BLBaseCurriculumModel *model = self.list[index];
    if (model.type == 3) {
        self.searchBtn.hidden = NO;
    } else {
        self.searchBtn.hidden = YES;
    }
}


- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.categoryListContainerView didClickSelectedItemAtIndex:index];
    BLBaseCurriculumModel *model = self.list[index];
    if (model.type == 3) {
        self.searchBtn.hidden = NO;
    } else {
        self.searchBtn.hidden = YES;
    }
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
    return self.list.count;
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getBaseCurriculumTypeAPI isEqual:manager]) {
        return @{@"modelId":@(_modelId),
                 @"functionType":@(_functionType)
                 };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getBaseCurriculumTypeAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray<BLBaseCurriculumModel *> *list = [NSArray yy_modelArrayWithClass:[BLBaseCurriculumModel class] json:[data objectForKey:@"data"]];
            NSMutableArray *titles = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(BLBaseCurriculumModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [titles addObject:obj.title?obj.title:@""];
            }];
            self.list = list;
            CGFloat width = 90 * list.count + list.count * 2;
            self.categoryTitleView.frame = CGRectMake(0, 0, width, 26);
            self.categoryTitleView.titles = titles;
            [self.categoryTitleView reloadData];
            [self.categoryListContainerView reloadData];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}


- (BLGetBaseCurriculumTypeAPI *)getBaseCurriculumTypeAPI {
    if (!_getBaseCurriculumTypeAPI) {
        _getBaseCurriculumTypeAPI = [[BLGetBaseCurriculumTypeAPI alloc] init];
        _getBaseCurriculumTypeAPI.mj_delegate = self;
        _getBaseCurriculumTypeAPI.paramSource = self;
    }
    return _getBaseCurriculumTypeAPI;
}

@end
