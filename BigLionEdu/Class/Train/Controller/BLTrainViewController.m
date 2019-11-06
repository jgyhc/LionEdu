//
//  BLTrainViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/21.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainViewController.h"
#import "BLTrainContentViewController.h"
#import "AdaptScreenHelp.h"
#import "BLModuleSingleton.h"
#import <SDWebImage.h>
#import "ZLUserInstance.h"

@interface BLTrainViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>



@end

@implementation BLTrainViewController

- (void)viewDidLoad {
    if (self.titles == nil) {
        self.titles = [BLModuleSingleton sharedInstance].titles;
    }
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.categoryView.titles = self.titles;
    self.categoryView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorWidth = 20;
    lineView.indicatorColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0];
    self.categoryView.indicators = @[lineView];
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    self.listContainerView.didAppearPercent = 0.01; //滚动一点就触发加载
    [self.view addSubview:self.listContainerView];
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
    if (_selectIndex) {
        __weak typeof(self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself.categoryView selectItemAtIndex:wself.selectIndex];
            [wself.listContainerView didClickSelectedItemAtIndex:wself.selectIndex];
        });
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    if (_categoryView) {
        [self.categoryView selectItemAtIndex:self.selectIndex];
        [self.listContainerView didClickSelectedItemAtIndex:self.selectIndex];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//
//    if (![self isKindOfClass:[NaviSegmentedControlViewController class]]) {
//        self.categoryView.frame = CGRectMake(0, 0, self.view.bounds.size.width, [self preferredCategoryViewHeight]);
//    }
    self.categoryView.frame = CGRectMake(0, StatusBarHeight(), self.view.bounds.size.width, [self preferredCategoryViewHeight]);
    self.listContainerView.frame = CGRectMake(0, StatusBarHeight() + [self preferredCategoryViewHeight], self.view.bounds.size.width, self.view.bounds.size.height - StatusBarHeight() - [self preferredCategoryViewHeight]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //处于第一个item的时候，才允许屏幕边缘手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader setValue:[ZLUserInstance sharedInstance].token forHTTPHeaderField:@"Authorization"];
    [downloader setValue:[ZLUserInstance sharedInstance].token forHTTPHeaderField:@"token"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (CGFloat)preferredCategoryViewHeight {
    return 50;
}

- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index {
    BLHomePageItemModel *model = [BLModuleSingleton sharedInstance].modules[index];
    BLTrainContentViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainContentViewController"];
    viewController.modelId = model.Id;
    viewController.index = index;
    return viewController;
}

- (JXCategoryTitleView *)categoryView {
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.titleColor =  [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
        _categoryView.titleSelectedColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:94/255.0 alpha:1.0];
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = YES;
        _categoryView.titleLabelZoomScale = 1.3;
        _categoryView.titleFont = [UIFont boldSystemFontOfSize:17];
        [_categoryView setBackgroundColor:[UIColor whiteColor]];
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (_listContainerView == nil) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    }
    return _listContainerView;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    if (_shouldHandleScreenEdgeGesture) {
        self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    }
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<JXCategoryListContentViewDelegate> list = [self preferredListAtIndex:index];
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

@end
