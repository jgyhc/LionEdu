//
//  AlipayManager.m
//  ManJi
//
//  Created by Zgmanhui on 16/7/8.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import "AlipayManager.h"
//#import "Order.h"
//#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
@implementation AlipayManager
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static AlipayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AlipayManager alloc] init];
    });
    return instance;
}

#pragma mark -
#pragma mark   ==============产生随机订单号==============


+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}



#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
+ (void)goZhiFuBao:(Product *)product {
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
//    NSString *partner = @"2088221899552641";
//    NSString *seller = @"manjiwang@qq.com";
//    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALKcux2O9eLA46OB5ey437Zu6FBc7gk2M7bv31yMLAwtHFtSCLuYPCNEVS70SyXy2gcWDNtXrhOf4ENga4xd4v+PotetyT/s9SS57oHLQF5QNxC5Im4Im22grAxZ2giuCkCMTPrlDyvNXgXYQDxsdCHR5zq0EQBWnmiDP95+sfoPAgMBAAECgYAvt+nRwtD0bL4kf97SuK2kCstsNPevZFi6pilRi211L1QlHayRmeFvNqFfcwrkr5YKUJzMuQcb3RnIRmlVTfwIAp735gXTAmKUoScsGlk/ZkrR1NX/wHfJ4DfO1WAcU8PXir2ID0Fkgg9cerfy4xXeZ5HDEoS94S18Cj8dzfCn4QJBAN1wu/MPGZ1/r36PBXbttxzJA430wuKK6MITwrI6v2qHhCbUXZ+UFTYvkUCS09dA1EJip1nqW9XyFHiA62YXWd8CQQDOfN9urCgmSrwpnH7dpz1WKpLPY9D7LE8BZcktSedRsM1oIZBDBJLN7LJZw/08C3fS3Cky/5z5VdswM+cTp8XRAkBmQEYpaBGV7n3k3LnTPtVND2z6wcizvxzXcTR4BDSbRlQ5cdqBc2mQCcrynFoBjUf2F4PbOyKI2i2lrzIDhEjVAkAPLhr29e0Vs5TVsk2ZWfwmY4bbfEkWzhEY1zTNAYvh84+GQkFqy+FHBkmuU7xAN8+dTtYwi54srmUozAgG5+ShAkEAj6KlqoUh1LXczuW8hT54VPKnfku+SmX4/nOEotzKq8EOAioYGG5ykx2w43n0jNYi8Z9X5hMid+fgtmsqnpLGUA==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    

    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.sellerID = seller;
//    order.outTradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
//    order.subject = product.subject; //商品标题
//    order.body = product.body; //商品描述
//    order.totalFee = [NSString stringWithFormat:@"%.2f", product.price]; //商品价格
//    order.notifyURL =  @"http://pay.manjiwang.com/api/payment/alipaysdkpay/notify_url.aspx"; //回调URL
//    
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showURL = @"m.alipay.com";
//    
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"manjiwang";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        NSLog(@"%@", orderString);
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//        }];
//    }

}

- (void)zhifubaoPay:(NSString *)orderString resultBlock:(void(^)(NSDictionary *resultDic))result {
    NSString *appScheme = @"biglin";
    self.AlipayManagerBlock = result;
    if (orderString != nil) {
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            result(resultDic);
        }];
    }
}

@end


@implementation Product



@end
