//
//  BLMailSearchContentView.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLMailSearchContentView.h"
#import "BLMallIndexCollectionViewCell.h"
#import "NTCatergory.h"
#import <Masonry.h>
#import "BLGoodsModel.h"
#import "BLGetGoodsListAPI.h"
#import <MJRefresh.h>
#import <YYModel.h>
#import "BLGoodsDetailViewController.h"
#import "AdaptScreenHelp.h"
#import "BLVideoClassDetailViewController.h"
#import <LCProgressHUD.h>

@interface BLMailSearchContentView ()<UICollectionViewDelegate, UICollectionViewDataSource, CTAPIManagerParamSource, MJAPIBaseManagerDelegate, BLMallIndexCollectionViewCellDelegate>


@property (nonatomic, strong) BLGetGoodsListAPI * getGoodsListAPI;
@property (nonatomic, strong) NSMutableArray <BLGoodsModel *> *datas;
@property (nonatomic, assign) NSInteger page;

@end

@implementation BLMailSearchContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bl_init];
    }
    return self;
}

- (void)bl_init {
    _datas = [NSMutableArray array];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
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

    [self.collectionView reloadData];
}

- (void)bl_refresh {
    if (self.datas.count == 0) {
        self.page = 1;
        [self.getGoodsListAPI loadData];
    }
}

- (void)bl_search {
    self.page = 1;
    [self.getGoodsListAPI loadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLMallIndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BLMallIndexCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.datas[indexPath.item];
    cell.delegate = self;
    return cell;
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
        [self.viewController.navigationController pushViewController:viewController animated:YES];
    } else if ([tmodel.type isEqualToString:@"2"]) {
        [LCProgressHUD show:@"直播功能正在开发中..."];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
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
            if (self.page == 1) {
                [self.datas removeAllObjects];
            }
            if (self.page == 1 && models.count < 20) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.datas addObjectsFromArray:models];
            [self.collectionView reloadData];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *loyout = [UICollectionViewFlowLayout new];
        loyout.sectionInset = UIEdgeInsetsMake(NTWidthRatio(12), NTWidthRatio(12), NTWidthRatio(12), NTWidthRatio(12));
        loyout.itemSize = CGSizeMake(NTWidthRatio(167), NTWidthRatio(251));
        loyout.minimumLineSpacing = NTWidthRatio(10);
        loyout.minimumInteritemSpacing = NTWidthRatio(10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, NT_SCREEN_WIDTH, (NT_SCREEN_HEIGHT - NavigationHeight() - 50)) collectionViewLayout:loyout];
        [_collectionView registerNib:[UINib nibWithNibName:@"BLMallIndexCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BLMallIndexCollectionViewCell"];
        _collectionView.backgroundColor = [UIColor nt_colorWithHexString:@"#F2F5F5"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (BLGetGoodsListAPI *)getGoodsListAPI {
    if (!_getGoodsListAPI) {
        _getGoodsListAPI = [[BLGetGoodsListAPI alloc] init];
        _getGoodsListAPI.mj_delegate = self;
        _getGoodsListAPI.paramSource = self;
    }
    return _getGoodsListAPI;
}



@end
