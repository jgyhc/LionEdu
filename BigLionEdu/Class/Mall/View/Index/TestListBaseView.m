//
//  TestListBaseView.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "TestListBaseView.h"
#import "AdaptScreenHelp.h"
#import "ZLCollectionViewDelegateManager.h"
#import "BLGoodsDetailViewController.h"
#import "BLGetGoodsListAPI.h"
#import <MJRefresh.h>
#import <MJPlaceholder.h>
#import "BLGoodsModel.h"
#import <YYModel.h>
#import "BLMallIndexCollectionViewCell.h"
#import "BLVideoClassDetailViewController.h"
#import "NTCatergory.h"
#import <LCProgressHUD.h>

@interface TestListBaseView()<ZLCollectionViewDelegateManagerDelegate, CTAPIManagerParamSource, MJAPIBaseManagerDelegate, BLMallIndexCollectionViewCellDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) ZLCollectionViewDelegateManager *manager;

@property (nonatomic, strong) BLGetGoodsListAPI * getGoodsListAPI;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray * datas;

@end

@implementation TestListBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self.manager reloadData];
        _page = 1;
        __weak typeof(self) wself = self;
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            wself.page = 1;
            [wself.getGoodsListAPI loadData];
        }];
        self.collectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            wself.page ++;
            [wself.getGoodsListAPI loadData];
        }];
        
        MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
        view.noDataPlacehoderParam = @{
                                       @"title": @"暂时没有什么数据",
                                       @"image":[UIImage imageNamed:@"placeholder"]
                                       };
        self.collectionView.placeholderView = view;
        self.collectionView.backgroundColor = [UIColor nt_colorWithHexString:@"#F2F5F5"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCurrentList) name:@"Mall_reset_refresh" object:nil];
    }
    return self;
}

- (void)setModelId:(NSString *)modelId {
    _modelId = modelId;
    [self.getGoodsListAPI loadData];
}

- (void)setType:(NSString *)type {
    _type = type;
}

- (void)setLabelId:(NSString *)labelId {
    _labelId = labelId;
}

- (void)refreshCurrentList {
    self.labelId = @"";
    self.type = @"";
    self.page = 1;
    [self.getGoodsListAPI loadData];
}

- (void)bl_refresh {
    self.page = 1;
    [self.getGoodsListAPI loadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark -- ZLCollectionViewDelegateManagerDelegate method
- (NSArray<ZLCollectionViewSectionModel *> *)dataSource:(ZLCollectionViewDelegateManager *)manager {
    return @[({
        ZLCollectionViewSectionModel *sectionModel = [ZLCollectionViewSectionModel new];
        sectionModel.items = self.datas;
        sectionModel.insets = UIEdgeInsetsMake(14, flexibleWidth(15), 14, flexibleWidth(15));
        sectionModel.minimumLineSpacing = flexibleWidth(10);
        sectionModel.minimumInteritemSpacing = flexibleWidth(10);
        sectionModel;
    })];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView manager:(ZLCollectionViewDelegateManager *)manager {
    self.scrollCallback(scrollView);
}

- (void)didSelectRowAtModel:(ZLCollectionViewRowModel *)model manager:(ZLCollectionViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    BLGoodsModel *tmodel = model.data;
//    0：书籍 1：试卷2：直播3：套卷(套卷都不显示）4:录播
    if ([tmodel.type isEqualToString:@"0"] || [tmodel.type isEqualToString:@"1"]) {
        BLGoodsDetailViewController *viewControlelr = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLGoodsDetailViewController"];
        viewControlelr.goodsId = [NSString stringWithFormat:@"%ld", (long)tmodel.Id];
        [self.viewController.navigationController  pushViewController:viewControlelr animated:YES];
    } else if ([tmodel.type isEqualToString:@"4"]) {
        BLVideoClassDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLVideoClassDetailViewController"];
        viewController.recId = tmodel.Id;
        [self.viewController.navigationController pushViewController:viewController animated:YES];
    } else if ([tmodel.type isEqualToString:@"2"]) {
        [LCProgressHUD show:@"直播功能正在开发中..."];
    }
}

- (void)BLMallIndexCollectionViewCellDidSelect:(BLGoodsModel *)tmodel {
    //    0：书籍 1：试卷2：直播3：套卷(套卷都不显示）4:录播
    if ([tmodel.type isEqualToString:@"0"] || [tmodel.type isEqualToString:@"1"]) {
        BLGoodsDetailViewController *viewControlelr = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLGoodsDetailViewController"];
        viewControlelr.goodsId = [NSString stringWithFormat:@"%ld", (long)tmodel.Id];
        [self.viewController.navigationController  pushViewController:viewControlelr animated:YES];
    } else if ([tmodel.type isEqualToString:@"4"]) {
        BLVideoClassDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLVideoClassDetailViewController"];
        viewController.recId = tmodel.infoId;
        viewController.goodsId = tmodel.Id;
        [self.viewController.navigationController pushViewController:viewController animated:YES];
    } else if ([tmodel.type isEqualToString:@"2"]) {
        [LCProgressHUD show:@"直播功能正在开发中..."];
    }
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getGoodsListAPI isEqual:manager]) {
        return @{@"modelId": self.modelId,
                 @"pageNum":@(_page),
                 @"pageSize":@20,
                 @"type":self.type?:@"",
                 @"labelId": self.labelId?:@"",
                 @"title": self.title?:@""
                 };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getGoodsListAPI isEqual:manager]) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSDictionary *datas = [data objectForKey:@"data"];
            NSArray *list = [datas objectForKey:@"list"];
            NSArray<BLGoodsModel *> *models = [NSArray yy_modelArrayWithClass:[BLGoodsModel class] json:list];
            NSMutableArray *viewModels = [NSMutableArray array];
            [models enumerateObjectsUsingBlock:^(BLGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [viewModels addObject:({
                    ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
                    rowModel.identifier = @"BLMallIndexCollectionViewCell";
                    rowModel.cellSize = CGSizeMake(flexibleWidth(167), flexibleWidth(251));
                    rowModel.data = obj;
                    rowModel.delegate = self;
                    rowModel;
                })];
            }];
            if (self.page == 1) {
                [self.datas removeAllObjects];
            }
            [self.datas addObjectsFromArray:viewModels];
             if (list.count < 20) {
                 [self.collectionView.mj_footer endRefreshingWithNoMoreData];
             }
            [self.manager reloadData];
        } else if (code == 999) {
            [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark - JXPagingViewListViewDelegate

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"BLMallIndexCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BLMallIndexCollectionViewCell"];
        [_collectionView setBackgroundColor:[UIColor colorWithRed:242/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
    }
    return _collectionView;
}

- (ZLCollectionViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLCollectionViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.collectionView = self.collectionView;
    }
    return _manager;
}

- (BLGetGoodsListAPI *)getGoodsListAPI {
    if (!_getGoodsListAPI) {
        _getGoodsListAPI = [[BLGetGoodsListAPI alloc] init];
        _getGoodsListAPI.mj_delegate = self;
        _getGoodsListAPI.paramSource = self;
    }
    return _getGoodsListAPI;
}


- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}


@end
