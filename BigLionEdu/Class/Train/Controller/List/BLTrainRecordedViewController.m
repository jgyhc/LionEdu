//
//  BLTrainRecordedViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainRecordedViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryIndicatorLineView.h"
#import <Masonry.h>
#import "BLMyCollectModel.h"
#import <YYModel/NSObject+YYModel.h>
#import "BLTrainListVideoTableViewController.h"
#import "BLBaseCurriculumModel.h"
#import "BLGetBaseCurriculumTypeAPI.h"
#import "NTCatergory.h"

@interface BLTrainRecordedViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate,CTAPIManagerParamSource, MJAPIBaseManagerDelegate>

@property (nonatomic, strong) JXCategoryListContainerView *categoryListContainerView;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryTitleView;
@property (nonatomic, strong) NSArray <BLBaseCurriculumModel *>*titleModels;
@property (nonatomic, strong) BLGetBaseCurriculumTypeAPI * getBaseCurriculumTypeAPI;

@end

@implementation BLTrainRecordedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.categoryTitleView.titles = self.titles;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setSubViews];
    [self.getBaseCurriculumTypeAPI loadData];
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
    lineView.indicatorLineViewColor = [UIColor nt_colorWithHexString:@"#FF6B00"];
    self.categoryTitleView.indicators = @[lineView];
    self.categoryListContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    [self.view addSubview:self.categoryListContainerView];
    [self.categoryListContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.categoryTitleView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    self.categoryTitleView.delegate = self;
    self.categoryListContainerView.didAppearPercent = 0.01; //滚动一点就触发加载
    if (self.categoryTitleViewBackgroundColor) {
        self.categoryTitleView.backgroundColor = self.categoryTitleViewBackgroundColor;
    }
    
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
    BLBaseCurriculumModel *model = _titleModels[index];
    BLTrainListVideoTableViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainListVideoTableViewController"];
    viewController.superViewController = self.superViewController;
    viewController.functionTypeId = model.Id;
    viewController.modelId = model.modelId;
    viewController.type = model.type;
    viewController.searchStr = self.searchStr;
    return viewController;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleModels.count;
}

- (void)setSearchStr:(NSString *)searchStr {
    _searchStr = searchStr;
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getBaseCurriculumTypeAPI isEqual:manager]) {
        return @{@"modelId":@(_modelId),
                 @"functionType":@(0)
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
            BLBaseCurriculumModel *firstModel = list.firstObject;
            if (firstModel.functionTypeDTOList.count) {
                list = firstModel.functionTypeDTOList;
            }
            NSMutableArray *titles = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(BLBaseCurriculumModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [titles addObject:obj.title?obj.title:@""];
            }];
            if (firstModel) {
                self.titleModels = firstModel.functionTypeDTOList.count > 0 ? firstModel.functionTypeDTOList:@[firstModel];
            } else {
                self.titleModels = firstModel.functionTypeDTOList.count > 0 ? firstModel.functionTypeDTOList:@[];
                if (!list.count) {
                    BLBaseCurriculumModel *m = [BLBaseCurriculumModel new];
                    m.Id = self.functionTypeId;
                    m.modelId = self.modelId;
                    m.type = 3;
                    self.titleModels = @[m];
                }
            }
            
            CGFloat width = 90 * list.count + list.count * 2;
            if (firstModel.functionTypeDTOList.count <= 0 || list.count <= 0) {
                self.categoryTitleView.frame = CGRectMake(0, 0, width, 0);
                self.categoryTitleView.hidden = YES;
                [self.categoryListContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.categoryTitleView.mas_bottom).offset(-50);
                    make.left.right.bottom.mas_equalTo(self.view);
                }];
                self.categoryTitleView.titles = @[@""];
                [self.categoryTitleView reloadData];
            } else {
                self.categoryTitleView.frame = CGRectMake(0, 0, width, 26);
                self.categoryTitleView.titles = titles;
                [self.categoryTitleView reloadData];
            }
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
