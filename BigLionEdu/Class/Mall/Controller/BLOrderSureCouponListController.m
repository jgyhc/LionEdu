//
//  BLOrderSureCouponListController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/23.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLOrderSureCouponListController.h"
#import "BLSureOrderCouponListCell.h"
#import "NTCatergory.h"
#import <BlocksKit.h>

@interface BLOrderSureCouponListController ()<UITableViewDelegate, UITableViewDataSource, BLSureOrderCouponListCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BLOrderSureCouponListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    [self.tableView registerNib:[UINib nibWithNibName:@"BLSureOrderCouponListCell" bundle:nil] forCellReuseIdentifier:@"BLSureOrderCouponListCell"];
    self.tableView.rowHeight = NTWidthRatio(118);
    self.view.backgroundColor = self.tableView.backgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(bl_sure)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)bl_sure {
    !self.didSelectedCouponHandler?:self.didSelectedCouponHandler();
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.couponList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLSureOrderCouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLSureOrderCouponListCell"];
    cell.model = self.model.couponList[indexPath.section];
    cell.delegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (void)BLSureOrderCouponListCellDidSelected:(BLGoodsSureCouponModel *)model {
    if (model.isCanUse == 0) {
        return;
    }
    CGFloat price = self.model.price;
    model.isSelected = !model.isSelected;
    if (model.isSelected && [model.isLimited isEqualToString:@"1"]) {
        if (price < model.overPrice.floatValue) {
            model.isSelected = NO;
        }
    }
    [self.tableView reloadData];
}


@end
