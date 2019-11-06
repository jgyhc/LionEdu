//  领劵中心
//  BLCouponsCenterViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLCouponsCenterViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAPPMyselfGetreceiveCouponListAPI.h"
#import "BLMyCouponsItemModel.h"
#import <NSObject+YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import <MJPlaceholderView/MJPlaceholderView.h>
#import <MJPlaceholderView/UITableView+MJPlaceholder.h>
#import "BLCouponsCenterTableViewCell.h"
#import "BLTextAlertViewController.h"
#import "ZLUserInstance.h"
#import "UIViewController+ORAdd.h"

@interface BLCouponsCenterViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;

@property (nonatomic, strong) BLAPPMyselfGetreceiveCouponListAPI *appMyselfGetreceiveCouponListAPI;
@property (nonatomic, strong) BLAPPMyselfReceiveCouponAPI *appMyselfReceiveCouponAPI;

@property(nonatomic, strong) NSMutableArray <ZLTableViewRowModel *>*sectionModelItems;
@property (nonatomic, assign) NSInteger pageNum;
@property(nonatomic, strong) BLMyCouponsItemModel *couponsItemModel;

@end

@implementation BLCouponsCenterViewController{
    BLMyCouponslistModel *_selectedCouponslistModel;
    NSInteger _pageNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageNum = 1;
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.pageNum = 1;
        [wself.appMyselfGetreceiveCouponListAPI loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        if (wself.couponsItemModel.isLastPage) {
            [wself.tableView.mj_footer endRefreshing];
            return;
        }
        wself.pageNum ++;
        [wself.appMyselfGetreceiveCouponListAPI loadData];
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
- (BLAPPMyselfGetreceiveCouponListAPI *)appMyselfGetreceiveCouponListAPI{
    if (!_appMyselfGetreceiveCouponListAPI) {
        _appMyselfGetreceiveCouponListAPI =[[BLAPPMyselfGetreceiveCouponListAPI alloc]init];
        _appMyselfGetreceiveCouponListAPI.mj_delegate =self;
        _appMyselfGetreceiveCouponListAPI.paramSource =self;
    }
    return _appMyselfGetreceiveCouponListAPI;
}

-(BLAPPMyselfReceiveCouponAPI *)appMyselfReceiveCouponAPI {
    if (!_appMyselfReceiveCouponAPI) {
        _appMyselfReceiveCouponAPI =[[BLAPPMyselfReceiveCouponAPI alloc]init];
        _appMyselfReceiveCouponAPI.mj_delegate =self;
        _appMyselfReceiveCouponAPI.paramSource =self;
    }
    return _appMyselfReceiveCouponAPI;
}


- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.appMyselfGetreceiveCouponListAPI isEqual:manager]) {
        return @{@"pageNum":@(_pageNum),
                 @"pageSize":@(20)
                 };
    }
    if ([self.appMyselfReceiveCouponAPI isEqual:manager]) {
        return @{
                 @"couponId":@((_selectedCouponslistModel.modelid).intValue)
                 };
    }
    return nil;
}

-(void)manager:(CTAPIBaseManager *)manager callBackData:(id)data{
    if ([self.appMyselfGetreceiveCouponListAPI isEqual:manager]) {
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
        BLMyCouponsItemModel *coupons = [BLMyCouponsItemModel yy_modelWithJSON:model];
        _couponsItemModel = coupons;
        [coupons.list enumerateObjectsUsingBlock:^(BLMyCouponslistModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.sectionModelItems addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLCouponsCenterTableViewCell";
                rowModel.cellHeight = 123;
                rowModel.data = obj;
                rowModel;
            })];
        }];
        [self.manager reloadData];

    }
    
    if ([self.appMyselfReceiveCouponAPI isEqual:manager]) {
        NSInteger code =[[data objectForKey:@"code"] integerValue];
        if (code !=200) {
            return;
        }
        
        _selectedCouponslistModel.isDrawed = YES;
        [self.manager reloadData];
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma makr action
-(void)explainAction:(UIButton *)sender{
    BLTextAlertViewController *viewController = [[BLTextAlertViewController alloc] initWithTitle:@"使用说明" content:@"1.购买所有商品可用，有效期至领取之日起90天\n\n2.每个商品最多使用一张优惠券，（特殊的新人抵扣卷可叠加使用）\n\n 3.在参加活动中发现有违规行为（恶意批量注册、无效手机号、虚假信息等），将封停账号" buttons:@[@"知道了"] tapBlock:^(BLTextAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
        
    }];
    [self presentViewController:viewController animated:YES completion:nil] ;
}

-(void)getAction:(UIButton *)sender{
    _selectedCouponslistModel = _sectionModelItems[sender.tag-100].data;
    
    if (_selectedCouponslistModel.isDrawed) {
        //去使用
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[UIViewController currentViewController].navigationController.tabBarController setSelectedIndex:2];
        
        return;
    }
    
    [self.appMyselfReceiveCouponAPI loadData];
}

- (IBAction)howToGetMoreAction:(UIButton *)sender {
    BLTextAlertViewController *viewController = [[BLTextAlertViewController alloc] initWithTitle:@"如何获取更多优惠券" content:@"1.邀请好友：点击分享，邀请好友，好友注册成功后邀请者可获得优惠券。\n2.错题反馈：答题中发现问题，提交错题反馈，首位提交经采纳可获得优惠券。\n 3.系统反馈：发现APP问题，提交反馈，首位提交经采纳可获得优惠券。" buttons:@[@"知道了"] tapBlock:^(BLTextAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
        
    }];
    [self presentViewController:viewController animated:YES completion:nil] ;
}

#pragma makr table
-(NSMutableArray *)sectionModelItems{
    if (_sectionModelItems == nil) {
        _sectionModelItems = [NSMutableArray new];
    }
    return _sectionModelItems;
}


- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        sectionModel.items = _sectionModelItems;
        sectionModel;
    })];
}

- (void)cellInitializeWithModel:(ZLTableViewRowModel *)model cell:(UITableViewCell *)cell manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[BLCouponsCenterTableViewCell class]]) {
        BLCouponsCenterTableViewCell *centerCell = (BLCouponsCenterTableViewCell *)cell;
        centerCell.explainBtn.tag = indexPath.row;
        [centerCell.explainBtn addTarget:self action:@selector(explainAction:) forControlEvents:UIControlEventTouchUpInside];
        centerCell.getBtn.tag = indexPath.row+100;
        [centerCell.getBtn addTarget:self action:@selector(getAction:) forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}


@end
