//
//  BLCouponsFailureViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLCouponsFailureViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAPPMyselfGetMemberCouponListAPI.h"
#import "BLMyCouponsItemModel.h"
#import <NSObject+YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import <MJPlaceholderView/MJPlaceholderView.h>
#import <MJPlaceholderView/UITableView+MJPlaceholder.h>
#import "BLTextAlertViewController.h"
#import "BLCouponsFailureTableViewCell.h"

@interface BLCouponsFailureViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) BLAPPMyselfGetMemberCouponListAPI *appMyselfGetMemberCouponListAPI;
@property(nonatomic, strong) NSMutableArray *sectionModelItems;
@property (nonatomic, assign) NSInteger pageNum;
@property(nonatomic, strong) BLMyCouponsItemModel *couponsItemModel;

@end

@implementation BLCouponsFailureViewController {
    BLMyCouponslistModel *_selectedCouponslistModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageNum = 1;
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.pageNum = 1;
        [wself.appMyselfGetMemberCouponListAPI loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        if (wself.couponsItemModel.isLastPage) {
            [wself.tableView.mj_footer endRefreshing];
            return;
        }
        wself.pageNum ++;
        [wself.appMyselfGetMemberCouponListAPI loadData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"暂无优惠券",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
}


#pragma mark data
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.appMyselfGetMemberCouponListAPI isEqual:manager]) {
        return @{@"status":@(3),
                 @"pageNum":@(_pageNum),
                 @"pageSize":@(20)
                 };
    }
    return nil;
}

- (BLAPPMyselfGetMemberCouponListAPI *)appMyselfGetMemberCouponListAPI{
    if (!_appMyselfGetMemberCouponListAPI) {
        _appMyselfGetMemberCouponListAPI =[[BLAPPMyselfGetMemberCouponListAPI alloc]init];
        _appMyselfGetMemberCouponListAPI.mj_delegate =self;
        _appMyselfGetMemberCouponListAPI.paramSource =self;
    }
    return _appMyselfGetMemberCouponListAPI;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    
        
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    
    if (code != 200) {
        return;
    }
    
    if (self.pageNum == 1) {
        [self.sectionModelItems removeAllObjects];
    }

    id model = [data objectForKey:@"data"];
    _couponsItemModel = [BLMyCouponsItemModel yy_modelWithJSON:model];
    [self reloadSectionModelWithIsCheckSelected:NO];
    
    [self.manager reloadData];

}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)reloadSectionModelWithIsCheckSelected:(BOOL)isCheckSelected{
        
    [_couponsItemModel.list enumerateObjectsUsingBlock:^(BLMyCouponslistModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self->_sectionModelItems addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLCouponsFailureTableViewCell";
            rowModel.cellHeight = 116;
            rowModel.data = obj;
            rowModel;
        })];
    }];
    
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        sectionModel.items = self.sectionModelItems;
        sectionModel;
    })];
}



- (void)cellInitializeWithModel:(ZLTableViewRowModel *)model cell:(UITableViewCell *)cell manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath{
    
    if ([model.identifier isEqualToString:@"BLCouponsFailureTableViewCell"]) {
        BLCouponsFailureTableViewCell *tableViewCell = (BLCouponsFailureTableViewCell *)cell;
        [tableViewCell.desBtn addTarget:self action:@selector(desAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {

}

-(void)desAction:(UIButton *)sender{
    BLTextAlertViewController *viewController = [[BLTextAlertViewController alloc] initWithTitle:@"如何获取更多优惠券" content:@"1.购买所有商品可用，有效期至领取之日起90天。\n2.每个商品最多使用一张优惠券，（特殊的新人抵扣卷可叠加使用。\n 3.在参加活动中发现有违规行为（恶意批量注册、无效手机号、虚假信息等），将封停账号。" buttons:@[@"知道了"] tapBlock:^(BLTextAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
        
    }];
    [self presentViewController:viewController animated:YES completion:nil] ;
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

-(NSMutableArray *)sectionModelItems {
    if (_sectionModelItems == nil) {
        _sectionModelItems = [NSMutableArray new];
    }
    return _sectionModelItems;
}


@end
