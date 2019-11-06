//  我的优惠券
//  BLMyCouponsViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyCouponsViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAPPMyselfGetMemberCouponListAPI.h"
#import "BLMyCouponsItemModel.h"
#import <NSObject+YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import <MJPlaceholderView/MJPlaceholderView.h>
#import <MJPlaceholderView/UITableView+MJPlaceholder.h>
#import "BLCouponViewController.h"
#import "BLCouponsTableViewCell.h"
#import "BLTextAlertViewController.h"
#import "BLBarCodeScannerViewController.h"
#import "ZLUserInstance.h"
#import "UIViewController+ORAdd.h"

@interface BLMyCouponsViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource, BLCouponsTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) BLAPPMyselfGetMemberCouponListAPI *appMyselfGetMemberCouponListAPI;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) BOOL isLastPage;

@property(nonatomic, strong) NSMutableArray *sectionModelItems;
@property(nonatomic, strong) BLMyCouponsItemModel *couponsItemModel;

@end

@implementation BLMyCouponsViewController{
    BLMyCouponslistModel *_selectedCouponslistModel;
    NSInteger _pageNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [self rightBarBtn];
    
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

#pragma mark view

-(UIBarButtonItem *)rightBarBtn{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 40)];
    [btn addTarget:self action:@selector(exchange:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"兑换卡卷" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"TsangerJinKai03" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    
    [btn setAttributedTitle:string forState:UIControlStateNormal];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return rightBarBtn;
}


#pragma mark action
-(void)exchange:(UIButton *)sender{
    BLCouponViewController *viewController = [[BLCouponViewController alloc] init];
    viewController.actionBlock = ^(CouponViewAlertAction action) {
        switch (action) {
            case exChangeSuccess:
                [self.tableView.mj_header beginRefreshing];
                break;
            case scan:
                [self.navigationController pushViewController:[BLBarCodeScannerViewController new] animated:true];
                break;
            default:
                break;
        }
    };
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)desAction:(UIButton *)sender{
    BLTextAlertViewController *viewController = [[BLTextAlertViewController alloc] initWithTitle:@"优惠券使用细则" content:@"1.购买所有商品可用，有效期至领取之日起90天。\n2.每个商品最多使用一张优惠券，（特殊的新人抵扣卷可叠加使用。\n 3.在参加活动中发现有违规行为（恶意批量注册、无效手机号、虚假信息等），将封停账号。" buttons:@[@"知道了"] tapBlock:^(BLTextAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
        
    }];
    [self presentViewController:viewController animated:YES completion:nil] ;
    
//    BLTextAlertViewController *viewController = [[BLTextAlertViewController alloc] initWithTitle:@"1.购买所有商品可用，有效期至领取之日起90天 \r\n2.每个商品最多使用一张优惠券，（特殊的新人抵扣卷可叠加使用）\r\n 3.在参加活动中发现有违规行为（恶意批量注册、无效手机号、虚假信息等），将封停账号 " buttons:@[@"知道了"] tapBlock:^(BLTextAlertViewContror, NSString * _Nonnull title, NSInteger buttonIndex) {
//        
//    }];
//    [self presentViewController:viewController animated:YES completion:nil] ;
}

#pragma mark data

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.appMyselfGetMemberCouponListAPI isEqual:manager]) {
        return @{@"status":@(2),
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

- (void)toUserCoupons {
    [self.navigationController popViewControllerAnimated:NO];
    [[UIViewController currentViewController].navigationController.tabBarController setSelectedIndex:2];
}

#pragma mark tableView
-(NSMutableArray *)sectionModelItems {
    if (_sectionModelItems == nil) {
        _sectionModelItems = [NSMutableArray new];
        [_sectionModelItems addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLCouponsFooterTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
    }
    return _sectionModelItems;
}

-(void)reloadSectionModelWithIsCheckSelected:(BOOL)isCheckSelected{
    
    [self.sectionModelItems removeLastObject];
    
    [_couponsItemModel.list enumerateObjectsUsingBlock:^(BLMyCouponslistModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self->_sectionModelItems addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLCouponsTableViewCell";
            rowModel.cellHeight = 116;
            rowModel.data = obj;
            rowModel.delegate = self;
            rowModel;
        })];
    }];
    [_sectionModelItems addObject:({
        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
        rowModel.identifier = @"BLCouponsFooterTableViewCell";
        rowModel.cellHeight = 66;
        rowModel;
    })];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        sectionModel.items = self.sectionModelItems;
        sectionModel;
    })];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLCouponsFooterTableViewCell"]) {
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLCouponsFailureViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
//        _selectedCouponslistModel = _couponsItemModel.list[indexPath.row];
//        [self reloadSectionModelWithIsCheckSelected:YES];
//        [manager reloadData];
    }
}

- (void)cellInitializeWithModel:(ZLTableViewRowModel *)model cell:(UITableViewCell *)cell manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath{
    
    if ([model.identifier isEqualToString:@"BLCouponsTableViewCell"]) {
        BLCouponsTableViewCell *tableViewCell = (BLCouponsTableViewCell *)cell;
        [tableViewCell.desBtn addTarget:self action:@selector(desAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
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
