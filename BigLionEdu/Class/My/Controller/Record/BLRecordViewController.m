//
//  BLMyCollectViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLRecordViewController.h"
#import "BLRecordTableViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryIndicatorLineView.h"
#import <Masonry.h>
#import "BLMyRecordModel.h"
#import "BLAppModuleTypeGetAllBaseTypeAPI.h"
#import <YYModel/NSObject+YYModel.h>
#import "ZLUserInstance.h"

@interface BLRecordViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (nonatomic, strong) JXCategoryListContainerView *categoryListContainerView;

@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryTitleView;

@property (nonatomic, strong) NSMutableArray <BLMyRecordTypeModel *>*titleModels;

@property (nonatomic, strong) BLAppModuleTypeGetAllBaseTypeAPI *appModuleTypeGetAllBaseTypeAPI;
@end

@implementation BLRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setSubViews];
    self.titleModels = [NSMutableArray new];

    [self.appModuleTypeGetAllBaseTypeAPI loadData];
    
    
}

#pragma mark view
- (void)setSubViews{
    _categoryTitleView.titleColor = [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
    _categoryTitleView.titleSelectedColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    _categoryTitleView.titleColorGradientEnabled = YES;
    //    _categoryTitleView.titleLabelZoomEnabled = YES;
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
    [self.categoryTitleView reloadData];

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
    
    BLRecordTableViewController *vc =  [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLRecordTableViewController"];
       vc.modelID = self.titleModels[index].modelid;
       return vc;
}

#pragma mark data
- (BLAppModuleTypeGetAllBaseTypeAPI *)appModuleTypeGetAllBaseTypeAPI {
    if (!_appModuleTypeGetAllBaseTypeAPI) {
        _appModuleTypeGetAllBaseTypeAPI = [[BLAppModuleTypeGetAllBaseTypeAPI alloc] init];
        _appModuleTypeGetAllBaseTypeAPI.mj_delegate = self;
        _appModuleTypeGetAllBaseTypeAPI.paramSource = self;
    }
    return _appModuleTypeGetAllBaseTypeAPI;
}

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    return nil;
}

-(void)manager:(CTAPIBaseManager *)manager callBackData:(id)data{
    NSInteger code =[[data objectForKey:@"code"] integerValue];
    if (code !=200) {
        return;
    }
    id model =[data objectForKey:@"data"];
    NSMutableArray *titles = [NSMutableArray new];
    for (NSDictionary *dic in model) {
        BLMyRecordTypeModel *recordModel = [BLMyRecordTypeModel yy_modelWithJSON:dic];
        [self.titleModels addObject:recordModel];
        [titles addObject:recordModel.title];
    }
    self.categoryTitleView.titles = titles;
    [self setSubViews];
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
    return self.titleModels.count;
}



@end
