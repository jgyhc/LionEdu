//
//  BLMyCollectViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMistakesViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryIndicatorLineView.h"
#import "ZLUserInstance.h"

#import <Masonry.h>
#import "BLMistakesItemViewController.h"
#import "BLMyMistakeModel.h"
#import "BLAppModuleTypeGetAllBaseTypeAPI.h"
#import "BLAPPMyselfGetAppMyQuestionErrorInfoAPI.h"
#import "BLTextAlertViewController.h"

#import <YYModel/NSObject+YYModel.h>


@interface BLMistakesViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (nonatomic, strong) JXCategoryListContainerView *categoryListContainerView;

@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryTitleView;

@property (nonatomic, strong) NSMutableArray <BLMyMistakeModel *>*titleModels;

@property (nonatomic, strong) BLAppModuleTypeGetAllBaseTypeAPI *appModuleTypeGetAllBaseTypeAPI;
@property (nonatomic, strong) BLAPPMyselfGetAppMyQuestionErrorTypeAPI *appErrorSumAPI;

@end

@implementation BLMistakesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleModels = [NSMutableArray new];
    [self.appModuleTypeGetAllBaseTypeAPI loadData];
    
    
    UIImage *image = [[UIImage imageNamed:@"my_pdf"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(action_pdf)];
    
    [self.appErrorSumAPI loadData];
    [self or_titleWithErrorNum:@"0"];
}

- (void)action_pdf {
    BLTextAlertViewController *viewController = [[BLTextAlertViewController alloc] initWithTitle:@"大狮解小吼一声" content:@"每用户累计生成上限300题\n已累计生成0题，还剩300题。" buttons:@[@"确定生成PDF"] tapBlock:^(BLTextAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
        
    }];
    [self presentViewController:viewController animated:YES completion:nil] ;
}

- (void)or_titleWithErrorNum:(id)num {
    
    UILabel *label = (UILabel *)self.navigationItem.titleView;
    
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        label.font = [UIFont systemFontOfSize:19];
        label.textAlignment = NSTextAlignmentCenter;
        
        self.navigationItem.titleView = label;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"错题本(%@/300)", num]];
    [str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} range:NSMakeRange(3, str.length - 3)];
    label.attributedText = str;
    
}

#pragma mark data
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    return nil;
}

-(void)manager:(CTAPIBaseManager *)manager callBackData:(id)data{
    NSInteger code =[[data objectForKey:@"code"] integerValue];
    if (code !=200) {
        return;
    }
    
    if ([manager isEqual:self.appErrorSumAPI]) {
        
        [self or_titleWithErrorNum:data[@"data"]];
        return;
    }
    
    id model =[data objectForKey:@"data"];
    NSLog(@"--%@",model);
    NSMutableArray *titles = [NSMutableArray new];
    for (NSDictionary *dic in model) {
        BLMyMistakeModel *mistakeModel = [BLMyMistakeModel yy_modelWithJSON:dic];
        [self.titleModels addObject:mistakeModel];
        [titles addObject:mistakeModel.title];
    }
    self.categoryTitleView.titles = titles;
    [self setSubViews];
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}


#pragma makr view
-(void)setSubViews{
//    self.categoryTitleView.titles = self.titles;
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
    BLMistakesItemViewController *vc =  [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMistakesItemViewController"];
    vc.modelID = self.titleModels[index].modelid;
    return vc;
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

- (BLAppModuleTypeGetAllBaseTypeAPI *)appModuleTypeGetAllBaseTypeAPI {
    if (!_appModuleTypeGetAllBaseTypeAPI) {
        _appModuleTypeGetAllBaseTypeAPI = [[BLAppModuleTypeGetAllBaseTypeAPI alloc] init];
        _appModuleTypeGetAllBaseTypeAPI.mj_delegate = self;
        _appModuleTypeGetAllBaseTypeAPI.paramSource = self;
    }
    return _appModuleTypeGetAllBaseTypeAPI;
}

- (BLAPPMyselfGetAppMyQuestionErrorTypeAPI *)appErrorSumAPI {
    if (!_appErrorSumAPI) {
        _appErrorSumAPI = [BLAPPMyselfGetAppMyQuestionErrorTypeAPI new];
        _appErrorSumAPI.mj_delegate = self;
        _appErrorSumAPI.paramSource = self;
    }
    return _appErrorSumAPI;
}




@end
