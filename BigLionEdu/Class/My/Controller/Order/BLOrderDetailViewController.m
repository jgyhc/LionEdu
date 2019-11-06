//
//  BLOrderDetailViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOrderDetailViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLOrderModel.h"
#import "BLOrderInfoAPI.h"
#import <YYModel.h>
#import "NTCatergory.h"
#import "BLOrderDetailGoodsHeaderCell.h"
#import "BLOrderDetailGoodsCell.h"
#import "BLOrderDetailStatusTableViewCell.h"
#import "BLOrderDetailAddressTableViewCell.h"
#import "BLOrderDetailPriceTableViewCell.h"
#import "BLOrderDetailInfoTableViewCell.h"
#import "BLOrderDetailLogisticsTableViewCell.h"
#import "BLBottomFilletTableViewCell.h"

@interface BLOrderDetailViewController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BLOrderModel *model;
@property (nonatomic, strong) BLOrderInfoAPI *orderInfoAPI;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation BLOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"BLOrderDetailGoodsHeaderCell" bundle:nil] forCellReuseIdentifier:@"BLOrderDetailGoodsHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BLOrderDetailGoodsCell" bundle:nil] forCellReuseIdentifier:@"BLOrderDetailGoodsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BLBottomFilletTableViewCell" bundle:nil] forCellReuseIdentifier:@"BLBottomFilletTableViewCell"];
    [self.manager reloadData];
    [self.orderInfoAPI loadData];
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (UIView *)listView {
    return self.view;
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return self.datas;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [data[@"code"] integerValue];
    if (code == 200 && [manager isEqual:self.orderInfoAPI]) {
        self.model = [BLOrderModel yy_modelWithJSON:data[@"data"]];
        
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        NSMutableArray *items = [NSMutableArray array];
        sectionModel.items = items;
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOrderDetailStatusTableViewCell";
            rowModel.cellHeight = 75;
            rowModel.data = self.model;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOrderDetailAddressTableViewCell";
            rowModel.cellHeight = 81;
            rowModel.data = self.model;
            rowModel;
        })];
        [self.datas addObject:sectionModel];
        
        
        ZLTableViewSectionModel *goodsSection = [ZLTableViewSectionModel new];
        NSMutableArray *goodsSectionItems = [NSMutableArray array];
        goodsSection.headerBackgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
        goodsSection.headerHeight = 10;
        goodsSection.items = goodsSectionItems;
        [goodsSectionItems addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOrderDetailGoodsHeaderCell";
            rowModel.cellHeight = 40;
            rowModel;
        })];
        for (NSInteger i = 0; i < self.model.orderGoodsList.count; i ++) {
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOrderDetailGoodsCell";
            rowModel.cellHeight = 90;
            rowModel.data = self.model.orderGoodsList[i];
            [goodsSectionItems addObject:rowModel];
        }
        ZLTableViewRowModel *btmModel = [ZLTableViewRowModel new];
        btmModel.identifier = @"BLBottomFilletTableViewCell";
        btmModel.cellHeight = 10;
        [goodsSectionItems addObject:btmModel];
        
        [self.datas addObject:goodsSection];
        
        ZLTableViewSectionModel *priceSectionModel = [ZLTableViewSectionModel new];
        NSMutableArray *priceSectionItems = [NSMutableArray array];
        priceSectionModel.items = priceSectionItems;
        priceSectionModel.headerBackgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
        priceSectionModel.headerHeight = 10;
        [priceSectionItems addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOrderDetailPriceTableViewCell";
            rowModel.cellHeight = 119;
            rowModel.data = self.model;
            rowModel;
        })];
        [self.datas addObject:priceSectionModel];

        ZLTableViewSectionModel *infoSectionModel = [ZLTableViewSectionModel new];
        NSMutableArray *infoSectionItems = [NSMutableArray array];
        infoSectionModel.items = infoSectionItems;
        infoSectionModel.headerBackgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
        infoSectionModel.headerHeight = 10;
        [infoSectionItems addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOrderDetailInfoTableViewCell";
            rowModel.cellHeight = 104;
            rowModel.data = self.model;
            rowModel;
        })];
        [self.datas addObject:infoSectionModel];

//        订单状态(1：待付款，2：待发货，3：待收货，4：退款中，5：交易关闭，6：交易成功，7：交易失败)
        if (self.model.status.integerValue == 3 || self.model.status.integerValue == 6) {
            ZLTableViewSectionModel *copySectionModel = [ZLTableViewSectionModel new];
            NSMutableArray *copySectionItems = [NSMutableArray array];
            copySectionModel.items = copySectionItems;
            copySectionModel.headerBackgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
            copySectionModel.headerHeight = 10;
            [copySectionItems addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLOrderDetailLogisticsTableViewCell";
                rowModel.cellHeight = 48;
                rowModel.data = self.model;
                rowModel;
            })];
            [self.datas addObject:copySectionModel];
        }
        
        [self.manager reloadData];
    }
}

- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    return @{@"id": self.goodsId,
             @"singleType": @(self.singleType)
    };
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (BLOrderInfoAPI *)orderInfoAPI {
    if (!_orderInfoAPI) {
        _orderInfoAPI = [BLOrderInfoAPI new];
        _orderInfoAPI.mj_delegate = self;
        _orderInfoAPI.paramSource = self;
    }
    return _orderInfoAPI;
}

@end
