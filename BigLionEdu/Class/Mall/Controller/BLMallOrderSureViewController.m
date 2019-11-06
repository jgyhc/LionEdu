//
//  BLMallOrderSureViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//  

#import "BLMallOrderSureViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLSubmitOrderAPI.h"
#import "BLGetExpressFeeAPI.h"
#import "BLGetConfirmGoodsAPI.h"
#import "BLGetConfirmCouponAPI.h"
#import "BLAreaManager.h"
#import "BLGetDefaultAddressAPI.h"
#import "BLAddressModel.h"
#import "BLAddressListViewController.h"
#import <YYModel.h>
#import <LCProgressHUD.h>
#import "BLGoodsSureModel.h"
#import "BLOrderSureAddressTableViewCell.h"
#import "BLOrderSureGoodsTableViewCell.h"
#import "BLOrderSureQuantityTableViewCell.h"
#import "BLOrderSureDistributionTableViewCell.h"
#import "BLOrderSureSubtotalTableViewCell.h"
#import "BLOrderSureMessageTableViewCell.h"
#import "BLOrderSureCouponsTableViewCell.h"
#import "BLOrderSurePayWayTableViewCell.h"
#import "MJWeChatSDK.h"
#import "BLGoodsPaySuccessController.h"
#import "BLGoodsPayFaileController.h"
#import "BLOrderSureCouponListController.h"
#import <BlocksKit.h>
#import "AlipayManager.h"
#import "BLPaperBuyAlertViewController.h"
#import "BLMyInterestViewController.h"

@interface BLMallOrderSureViewController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource, BLOrderSureQuantityTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *buyNumLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong) ZLTableViewDelegateManager * manager;
@property (nonatomic, strong) BLSubmitOrderAPI *submitOrderAPI;
@property (nonatomic, strong) BLGetConfirmGoodsAPI *getConfirmGoodsAPI;
@property (nonatomic, strong) BLGetDefaultAddressAPI *getDefaultAddressAPI;
//默认地址
@property (nonatomic, strong) BLAddressModel *addressModel;
//总价和总计
@property (nonatomic, strong) BLGoodsSureBuyNumModel *buyNumModel;
//每组的商品
@property (nonatomic, strong) NSArray <BLGoodsSureConfirmModel *> *goods;

@property (nonatomic, strong) BLGoodsSurePayWayModel *aliPayModel;
@property (nonatomic, strong) BLGoodsSurePayWayModel *wxPayModel;
@property (nonatomic, strong) BLGoodsSureMarkModel *markModel;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation BLMallOrderSureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.datas = [NSMutableArray array];
    [self.manager reloadData];
    if (self.goodsId) {
        [self.getDefaultAddressAPI loadData];
    } else if (self.paperModel) {
        [self bl_loadPaperOrderDatas];
    }
    [self.submitBtn addTarget:self action:@selector(bl_submit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)bl_submit {
    if (!self.addressModel && !self.paperModel) {
        [LCProgressHUD show:@"请选择收货地址"];
        return;
    }
    [self.submitOrderAPI loadData];
}


- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return self.datas;
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLOrderSureAddressTableViewCell"]) {
        BLAddressListViewController *controller = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLAddressListViewController"];
        if (self.addressModel) {
            controller.addressId = self.addressModel.Id;
        }
        __weak typeof(self) wself = self;
        [controller setDidSelectAddressBlock:^(NSDictionary * _Nonnull address) {
            wself.addressModel = [BLAddressModel yy_modelWithJSON:address];
            ZLTableViewSectionModel *section = self.datas.firstObject;
            //地址
            ZLTableViewRowModel *rowModel = section.items.firstObject;
            rowModel.data = wself.addressModel;
            [wself.manager reloadData];
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }
    if ([model.identifier isEqualToString:@"BLOrderSureCouponsTableViewCell"]) {
        BLGoodsSureConfirmModel *sectionModel = model.data;
        if (sectionModel.couponList.count > 0) {
            BLOrderSureCouponListController *controller = [BLOrderSureCouponListController new];
            controller.model = sectionModel;
            [self.navigationController pushViewController:controller animated:YES];
            [controller setDidSelectedCouponHandler:^{
                [self.manager reloadData];
                [self buyNumberDidChange:0];
            }];
        }
    }
    if ([model.data isKindOfClass:[BLGoodsSurePayWayModel class]]) {
        if ([model.data isEqual:self.wxPayModel]) {
            self.wxPayModel.select = YES;
            self.aliPayModel.select = NO;
        } else {
            self.wxPayModel.select = NO;
            self.aliPayModel.select = YES;
        }
        [self.manager reloadData];
    }
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [data[@"code"] integerValue];
    if ([manager isEqual:self.getDefaultAddressAPI]) {
    
        self.addressModel = [BLAddressModel yy_modelWithJSON:data[@"data"]];
        ZLTableViewSectionModel *section = [ZLTableViewSectionModel new];
        //地址
        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
        rowModel.cellHeight = -1;
        rowModel.identifier = @"BLOrderSureAddressTableViewCell";
        rowModel.data = self.addressModel?:[BLAddressModel new];
        section.items = @[rowModel];
        [self.datas addObject:section];
        [self.getConfirmGoodsAPI loadData];
        
    } else if ([self.getConfirmGoodsAPI isEqual:manager]) {
        NSLog(@"%@", data);
        NSArray <BLGoodsSureConfirmModel *>*arr = [NSArray yy_modelArrayWithClass:[BLGoodsSureConfirmModel class] json:data[@"data"]];
        self.goods = arr;
        self.buyNumModel = [BLGoodsSureBuyNumModel new];
        
        CGFloat price = 0.0;
        NSInteger allNum = 0;
        
        for (NSInteger i = 0; i < arr.count; i ++) {
            ZLTableViewSectionModel *section = [ZLTableViewSectionModel new];
            section.headerHeight = 10;
            section.footerHeight = 0.01;
            section.headerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
            NSMutableArray *sectionItems = [NSMutableArray array];
            
            //上圆角
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.cellHeight = 10;
            rowModel.identifier = @"BLOrderSureTopRoundedCornersTableViewCell";
            [sectionItems addObject:rowModel];
            
            BLGoodsSureConfirmModel *cmodel = arr[i];
            
            for (NSInteger j = 0; j < cmodel.confirmGoodsList.count; j ++) {
                BLGoodsSureModel *obj = cmodel.confirmGoodsList[j];
                //商品
                ZLTableViewRowModel *goodsRow = [ZLTableViewRowModel new];
                goodsRow.cellHeight = 120;
                goodsRow.identifier = @"BLOrderSureGoodsTableViewCell";
                goodsRow.data = obj;
                
                //购买数量
                ZLTableViewRowModel *buyNumRow = [ZLTableViewRowModel new];
                buyNumRow.cellHeight = 44;
                buyNumRow.identifier = @"BLOrderSureQuantityTableViewCell";
                buyNumRow.delegate = self;
                buyNumRow.data = obj;
                
                
                [sectionItems addObject:goodsRow];
                [sectionItems addObject:buyNumRow];
            }
            
            price += cmodel.price;
            allNum += cmodel.buyNumber;
            
            //配送方式
            ZLTableViewRowModel *expressRow = [ZLTableViewRowModel new];
            expressRow.cellHeight = 44;
            expressRow.identifier = @"BLOrderSureDistributionTableViewCell";
            expressRow.data = cmodel;
            [sectionItems addObject:expressRow];
            
            //小计
            ZLTableViewRowModel *priceRow = [ZLTableViewRowModel new];
            priceRow.cellHeight = 40;
            priceRow.identifier = @"BLOrderSureSubtotalTableViewCell";
            priceRow.data = cmodel;
            [sectionItems addObject:priceRow];
            
            //下圆角
            ZLTableViewRowModel *bottomRow = [ZLTableViewRowModel new];
            bottomRow.cellHeight = 10;
            bottomRow.identifier = @"BLOrderSureBottomRoundedCornersTableViewCell";
            [sectionItems addObject:bottomRow];
            
            section.items = sectionItems.copy;
            [self.datas addObject:section];
            
            //买家留言和优惠券
            ZLTableViewSectionModel *messageAndCoupons = [self messageAndCoupons:cmodel];
            [self.datas addObject:messageAndCoupons];
        }
        
        //总计和价格
        self.buyNumModel.price = [NSString stringWithFormat:@"%.2lf", price];
        self.buyNumModel.num = allNum;
        self.buyNumLab.text = [NSString stringWithFormat:@"共%ld件", (long)allNum];
        self.priceLab.text = self.buyNumModel.price;
        
        //支付
        ZLTableViewSectionModel *section3Model = [ZLTableViewSectionModel new];
        section3Model.headerHeight = 10;
        section3Model.footerHeight = 20.0;
        section3Model.headerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
        section3Model.footerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
        section3Model.items = @[
                               ({
                                   ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                   rowModel.cellHeight = 10;
                                   rowModel.identifier = @"BLOrderSureTopRoundedCornersTableViewCell";
                                   rowModel;
                               }),
                               ({
                                   ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                   rowModel.cellHeight = 44;
                                   rowModel.identifier = @"BLOrderSurePayWayTableViewCell";
                                   self.wxPayModel = [BLGoodsSurePayWayModel new];
                                   self.wxPayModel.icon = @"wx";
                                   self.wxPayModel.select = YES;
                                   rowModel.data = self.wxPayModel;;
                                   rowModel;
                               }),
                               ({
                                   ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                   rowModel.cellHeight = 44;
                                   rowModel.identifier = @"BLOrderSurePayWayTableViewCell";
                                   self.aliPayModel = [BLGoodsSurePayWayModel new];
                                   self.aliPayModel.icon = @"alipay";
                                   self.aliPayModel.select = NO;
                                   rowModel.data = self.aliPayModel;;
                                   rowModel;
                               }),
                               ({
                                   ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                   rowModel.cellHeight = 10;
                                   rowModel.identifier = @"BLOrderSureBottomRoundedCornersTableViewCell";
                                   rowModel;
                               })
                               ];
        
        [self.datas addObject:section3Model];
        [self.manager reloadData];
        
    } else if ([manager isEqual:self.submitOrderAPI] && code == 200) {
        if (self.aliPayModel.select == YES) {
            NSString *info = [data objectForKey:@"data"];
//            NSString *orderPayInfo = [info objectForKey:@"orderPayInfo"];
            [[AlipayManager sharedManager] zhifubaoPay:info resultBlock:^(NSDictionary *resultDic) {
                if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                    //拼团类型：0：单独购买，1：发起拼团，2：参加拼团
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        BLGoodsPaySuccessController *controller = [BLGoodsPaySuccessController new];
                        controller.groupId = self.groupId;
                        controller.groupType = self.groupType;
                        if (self.backToController) {
                            controller.backToController = self.backToController;
                        }
                        [self.navigationController pushViewController:controller animated:YES];
                    });
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        BLGoodsPayFaileController *controller = [BLGoodsPayFaileController new];
                        [self.navigationController pushViewController:controller animated:YES];
                    });
                }
            }];
        } else {
            NSDictionary *dic = data[@"data"];
            [[MJWeChatSDK shareInstance] payForWechat:dic[@"appid"] partnerId:dic[@"partnerid"] prepayId:dic[@"prepayid"] nonceStr:dic[@"noncestr"] timeStamp:dic[@"timestamp"] package:dic[@"package"] sign:dic[@"sign"] viewController:self resultBlock:^(NSNumber * _Nonnull errCode) {
                NSLog(@"%@", errCode);
                if (errCode.integerValue == 0) {
                    //拼团类型：0：单独购买，1：发起拼团，2：参加拼团
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        BLGoodsPaySuccessController *controller = [BLGoodsPaySuccessController new];
                        controller.groupId = self.groupId;
                        controller.groupType = self.groupType;
                        if (self.backToController) {
                            controller.backToController = self.backToController;
                        }
                        [self.navigationController pushViewController:controller animated:YES];
                    });
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        BLGoodsPayFaileController *controller = [BLGoodsPayFaileController new];
                        [self.navigationController pushViewController:controller animated:YES];
                    });
                }
            }];
        }
    } else if ([self.submitOrderAPI isEqual:manager] && code == 502) {
        //如果未添加兴趣
        NSArray *buttons = @[@{BLPaperBuyAlertControllerButtonTitleKey: @"确定",
                               BLPaperBuyAlertControllerButtonTextColorKey: [UIColor whiteColor],
                               BLPaperBuyAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                               BLPaperBuyAlertControllerButtonBorderColorKey: @1,
                               BLPaperBuyAlertControllerButtonNormalBackgroundColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                               BLPaperBuyAlertControllerButtonRoundedCornersKey:@14.5
                   },
                       @{BLPaperBuyAlertControllerButtonTitleKey: @"取消",
                               BLPaperBuyAlertControllerButtonTextColorKey: [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                               BLPaperBuyAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                               BLPaperBuyAlertControllerButtonBorderWidthKey: @1,
                               BLPaperBuyAlertControllerButtonNormalBackgroundColorKey:[UIColor whiteColor],
                               BLPaperBuyAlertControllerButtonRoundedCornersKey:@14.5
                   }
                   ];
                   __weak typeof(self) wself = self;
                   BLPaperBuyAlertViewController *viewController =
                      [[BLPaperBuyAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                                               content:@"到我的兴趣选择对应的兴趣即可解锁"
                                                               buttons:buttons tapBlock:^(BLPaperBuyAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
                          if ([title isEqualToString:@"确定"]) {
                              BLMyInterestViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMyInterestViewController"];
                              viewController.needPop = YES;
                              [wself.navigationController pushViewController:viewController animated:YES];
                          }
                          }];
                   viewController.textAlignment = NSTextAlignmentCenter;
                   [self presentViewController:viewController animated:YES completion:nil];
    }
}

#pragma mark --- 如果是购买试卷
- (void)bl_loadPaperOrderDatas {
 
    BLGoodsSureConfirmModel *confirm = [BLGoodsSureConfirmModel new];
    confirm.expressFee = @0;
    confirm.isPaper = YES;
    confirm.modelId = @"0";
    BLGoodsSureModel *goods = [BLGoodsSureModel new];
    goods.title = self.paperModel.title;
    goods.coverImg = self.paperModel.coverImg;
    goods.price = self.paperModel.price.stringValue;
    goods.goodsNum = 1;
    goods.Id = @(self.paperModel.goodsId).stringValue;
    confirm.confirmGoodsList = @[goods];
    self.goods = @[confirm];
    
    self.buyNumLab.text = @"共1件";
    CGFloat price = self.paperModel.price.floatValue;
    self.priceLab.text = [NSString stringWithFormat:@"%.2lf", price];
    
    ZLTableViewSectionModel *section = [ZLTableViewSectionModel new];
    section.headerHeight = 10;
    section.footerHeight = 0.01;
    section.headerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    NSMutableArray *sectionItems = [NSMutableArray array];
    
    //上圆角
    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
    rowModel.cellHeight = 10;
    rowModel.identifier = @"BLOrderSureTopRoundedCornersTableViewCell";
    [sectionItems addObject:rowModel];
    
    //商品
    ZLTableViewRowModel *goodsRow = [ZLTableViewRowModel new];
    goodsRow.cellHeight = 120;
    goodsRow.identifier = @"BLOrderSureGoodsTableViewCell";
    goodsRow.data = goods;
    [sectionItems addObject:goodsRow];
    
    //配送方式
    ZLTableViewRowModel *expressRow = [ZLTableViewRowModel new];
    expressRow.cellHeight = 44;
    expressRow.identifier = @"BLOrderSureDistributionTableViewCell";
    expressRow.data = confirm;
    [sectionItems addObject:expressRow];
    
    //下圆角
    ZLTableViewRowModel *bottomRow = [ZLTableViewRowModel new];
    bottomRow.cellHeight = 10;
    bottomRow.identifier = @"BLOrderSureBottomRoundedCornersTableViewCell";
    [sectionItems addObject:bottomRow];
    section.items = sectionItems.copy;
    [self.datas addObject:section];
    
    ZLTableViewSectionModel *msgSection = [ZLTableViewSectionModel new];
    msgSection.headerHeight = 10;
    msgSection.headerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    ZLTableViewRowModel *messageRow = [ZLTableViewRowModel new];
    messageRow.identifier = @"BLOrderSureMessageTableViewCell";
    messageRow.cellHeight = 40.0;
    messageRow.data = confirm;
    msgSection.items = @[messageRow];
    [self.datas addObject:msgSection];
    
    //支付
    ZLTableViewSectionModel *paySectionModel = [ZLTableViewSectionModel new];
    paySectionModel.headerHeight = 10;
    paySectionModel.footerHeight = 20.0;
    paySectionModel.headerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    paySectionModel.footerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    paySectionModel.items = @[
                           ({
                               ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                               rowModel.cellHeight = 10;
                               rowModel.identifier = @"BLOrderSureTopRoundedCornersTableViewCell";
                               rowModel;
                           }),
                           ({
                               ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                               rowModel.cellHeight = 44;
                               rowModel.identifier = @"BLOrderSurePayWayTableViewCell";
                               self.wxPayModel = [BLGoodsSurePayWayModel new];
                               self.wxPayModel.icon = @"wx";
                               self.wxPayModel.select = YES;
                               rowModel.data = self.wxPayModel;;
                               rowModel;
                           }),
                           ({
                               ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                               rowModel.cellHeight = 44;
                               rowModel.identifier = @"BLOrderSurePayWayTableViewCell";
                               self.aliPayModel = [BLGoodsSurePayWayModel new];
                               self.aliPayModel.icon = @"alipay";
                               self.aliPayModel.select = NO;
                               rowModel.data = self.aliPayModel;;
                               rowModel;
                           }),
                           ({
                               ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                               rowModel.cellHeight = 10;
                               rowModel.identifier = @"BLOrderSureBottomRoundedCornersTableViewCell";
                               rowModel;
                           })
                           ];
    
    [self.datas addObject:paySectionModel];
    [self.manager reloadData];
    
}


- (ZLTableViewSectionModel *)messageAndCoupons:(BLGoodsSureConfirmModel *)model {
    ZLTableViewSectionModel *section = [ZLTableViewSectionModel new];
    section.headerHeight = 10;
    section.headerBackgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    
    ZLTableViewRowModel *messageRow = [ZLTableViewRowModel new];
    messageRow.identifier = @"BLOrderSureMessageTableViewCell";
    messageRow.cellHeight = 40.0;
    messageRow.data = model;
    
    ZLTableViewRowModel *couponsRow = [ZLTableViewRowModel new];
    couponsRow.identifier = @"BLOrderSureCouponsTableViewCell";
    couponsRow.cellHeight = 40.0;
    couponsRow.data = model;
    section.items = @[messageRow, couponsRow];
    return section;
}

- (void)buyNumberDidChange:(NSInteger)num {
    CGFloat price = 0.0;
    NSInteger allNum = 0;
    //商品
    for (NSInteger i = 0; i < self.goods.count; i ++) {
        BLGoodsSureConfirmModel *obj = self.goods[i];
        price += obj.price;
        allNum += obj.buyNumber;
    }
    self.buyNumModel.price = [NSString stringWithFormat:@"%.2lf", price];
    self.buyNumModel.num = allNum;
    [self.manager reloadData];
    self.buyNumLab.text = [NSString stringWithFormat:@"共%ld件", (long)allNum];
    self.priceLab.text = self.buyNumModel.price;
    [self.manager reloadData];
}

- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    if ([manager isEqual:self.getConfirmGoodsAPI]) {
        return @{@"ids": self.goodsId?:@"",
                 @"province": @"重庆市",
                 @"groupType":self.groupType
        };
    } else if ([manager isEqual:self.submitOrderAPI]) {
        
        NSMutableArray *submitInfoDTOList = [NSMutableArray array];
        for (NSInteger i = 0; i < self.goods.count; i ++) {
            BLGoodsSureConfirmModel *obj = self.goods[i];
            NSArray *cids;
            NSMutableArray *confirmGoodsList = [NSMutableArray array];
            for (NSInteger j = 0; j < obj.confirmGoodsList.count; j ++) {
                BLGoodsSureModel *goods = obj.confirmGoodsList[j];
                cids = [obj.couponList bk_map:^id(BLGoodsSureCouponModel *cobj) {
                    if (cobj.isSelected) {
                        return cobj.Id;
                    }
                    return @"";
                }];
                [confirmGoodsList addObject:@{@"id": goods.Id,
                                              @"goodsNum": @(goods.goodsNum)
                }];
            }
            NSDictionary *dic = @{
                @"modelId": obj.modelId,
                @"expressFee": obj.expressFee,
                @"couponIds": [cids componentsJoinedByString:@","]?:@"",
                @"remark": obj.message?:@"",
                @"groupType": self.groupType?:@0,
                @"groupId": self.groupId?:@"",
                @"confirmGoodsList": confirmGoodsList
            };
            [submitInfoDTOList addObject:dic];
        }
        NSDictionary *params = @{@"addressId": @(self.addressModel.Id),
                                 @"payMethod": self.wxPayModel.select == YES ? @"1":@"0",
                                 @"submitInfoDTOList": submitInfoDTOList
        };
        return params;
    }
    return nil;
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

- (BLSubmitOrderAPI *)submitOrderAPI {
    if (!_submitOrderAPI) {
        _submitOrderAPI = [BLSubmitOrderAPI new];
        _submitOrderAPI.mj_delegate = self;
        _submitOrderAPI.paramSource = self;
    }
    return _submitOrderAPI;
}

- (BLGetConfirmGoodsAPI *)getConfirmGoodsAPI {
    if (!_getConfirmGoodsAPI) {
        _getConfirmGoodsAPI = [BLGetConfirmGoodsAPI new];
        _getConfirmGoodsAPI.mj_delegate = self;
        _getConfirmGoodsAPI.paramSource = self;
    }
    return _getConfirmGoodsAPI;
}


- (BLGetDefaultAddressAPI *)getDefaultAddressAPI {
    if (!_getDefaultAddressAPI) {
        _getDefaultAddressAPI = [BLGetDefaultAddressAPI new];
        _getDefaultAddressAPI.mj_delegate = self;
        _getDefaultAddressAPI.paramSource = self;
    }
    return _getDefaultAddressAPI;
}

@end
