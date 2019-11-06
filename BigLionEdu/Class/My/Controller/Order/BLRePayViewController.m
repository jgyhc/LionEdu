//
//  BLRePayViewController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/7.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLRePayViewController.h"
#import "BLRePayAPI.h"
#import "BLOrderInfoAPI.h"
#import "BLOrderModel.h"
#import <YYModel.h>
#import "AlipayManager.h"
#import "MJWeChatSDK.h"
#import "BLGoodsPaySuccessController.h"
#import "BLGoodsPayFaileController.h"
#import "BLBuyLionAPI.h"

@interface BLRePayViewController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *wxPay;
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;
@property (nonatomic, strong) BLOrderModel *model;
@property (nonatomic, strong) BLOrderInfoAPI *orderInfoAPI;
@property (nonatomic, strong) BLRePayAPI *rePayAPI;
@property (nonatomic, strong) BLBuyLionAPI *buyLionAPI;
@property (nonatomic, strong) BLBuyPackagePayAPI *buyPackageAPI;

@end

@implementation BLRePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    self.wxPay.selected = YES;
    if (self.orderId && !self.isBuyPackage) {
        [self.orderInfoAPI loadData];
    }
    self.moneyLab.text = self.price;
}

- (IBAction)bl_toPay:(id)sender {
    
    if (self.isBuyPackage) {
        [self.buyPackageAPI loadData];
    }else if (self.orderId) {
        [self.rePayAPI loadData];
    } else if (self.functionTypeId != 0 && self.functionTypeId) {
        [self.buyLionAPI loadData];
    }
    
}

- (IBAction)bl_wxPay:(id)sender {
    self.wxPay.selected = YES;
    self.aliPayBtn.selected = NO;
}

- (IBAction)bl_aliPay:(id)sender {
    self.wxPay.selected = NO;
    self.aliPayBtn.selected = YES;
}


- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [data[@"code"] integerValue];
    
    if (([manager isEqual:self.rePayAPI] || [manager isEqual:self.buyPackageAPI]) && code == 200) {
                if (self.aliPayBtn.selected == YES) {
                    NSString *info = [data objectForKey:@"data"];
        //            NSString *orderPayInfo = [info objectForKey:@"orderPayInfo"];
                    [[AlipayManager sharedManager] zhifubaoPay:info resultBlock:^(NSDictionary *resultDic) {
                        if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                            
                            //拼团类型：0：单独购买，1：发起拼团，2：参加拼团
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                if (self.isBuyPackage) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kBuyPackageSuccessNotification" object:nil];
                                    
                                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                                    return ;
                                }
                                
                                BLGoodsPaySuccessController *controller = [BLGoodsPaySuccessController new];
                                controller.groupId = @"";
                                controller.groupType = @0;
                                [self.navigationController pushViewController:controller animated:YES];
                            });
                        } else {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                if (self.isBuyPackage) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                    return ;
                                }
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
                                
                                if (self.isBuyPackage) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kBuyPackageSuccessNotification" object:nil];
                                    
                                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                                    return ;
                                }
                                
                                
                                BLGoodsPaySuccessController *controller = [BLGoodsPaySuccessController new];
                                controller.groupId = @"";
                                controller.groupType = @0;
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
    } else if ([manager isEqual:self.orderInfoAPI]) {
        self.model = [BLOrderModel yy_modelWithJSON:data[@"data"]];
        self.moneyLab.text = [NSString stringWithFormat:@"￥%@", self.model.dealPrice?:self.price];
    } else if ([manager isEqual:self.buyLionAPI]) {
        if (self.aliPayBtn.selected == YES) {
                    NSString *info = [data objectForKey:@"data"];
        //            NSString *orderPayInfo = [info objectForKey:@"orderPayInfo"];
                    [[AlipayManager sharedManager] zhifubaoPay:info resultBlock:^(NSDictionary *resultDic) {
                        if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                            //拼团类型：0：单独购买，1：发起拼团，2：参加拼团
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                BLGoodsPaySuccessController *controller = [BLGoodsPaySuccessController new];
                                controller.groupId = @"";
                                controller.groupType = @0;
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
                                controller.groupId = @"";
                                controller.groupType = @0;
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
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {

}

- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    if ([manager isEqual:self.rePayAPI]) {
        return @{@"id": self.orderId,
                 @"payMethod": self.wxPay.selected == YES ? @1 : @0,
                 @"singleType": @(self.singleType)
        };
    } else if ([manager isEqual:self.buyPackageAPI]) {
        return @{@"id": self.orderId,
                 @"payMethod": self.wxPay.selected == YES ? @1 : @0
        };
    } else if ([manager isEqual:self.orderInfoAPI]) {
        return  @{@"id": self.orderId?:@""};
    } else if ([manager isEqual:self.buyLionAPI]) {
        return @{@"functionTypeId": @(self.functionTypeId),
                 @"payMethod": self.wxPay.selected == YES ? @1 : @0
        };
    }
    return nil;
}

- (BLOrderInfoAPI *)orderInfoAPI {
    if (!_orderInfoAPI) {
        _orderInfoAPI = [BLOrderInfoAPI new];
        _orderInfoAPI.mj_delegate = self;
        _orderInfoAPI.paramSource = self;
    }
    return _orderInfoAPI;
}

- (BLRePayAPI *)rePayAPI {
    if (!_rePayAPI) {
        _rePayAPI = [BLRePayAPI new];
        _rePayAPI.mj_delegate = self;
        _rePayAPI.paramSource = self;
    }
    return _rePayAPI;
}

- (BLBuyPackagePayAPI *)buyPackageAPI {
    if (!_buyPackageAPI) {
        _buyPackageAPI = [BLBuyPackagePayAPI new];
        _buyPackageAPI.mj_delegate = self;
        _buyPackageAPI.paramSource = self;
    }
    return _buyPackageAPI;
}


- (BLBuyLionAPI *)buyLionAPI {
    if (!_buyLionAPI) {
        _buyLionAPI = [BLBuyLionAPI new];
        _buyLionAPI.mj_delegate = self;
        _buyLionAPI.paramSource = self;
    }
    return _buyLionAPI;
}


@end
