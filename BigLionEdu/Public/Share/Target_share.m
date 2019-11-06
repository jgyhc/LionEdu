//
//  Target_share.m
//  ManJi
//
//  Created by -- on 2018/12/21.
//  Copyright © 2018 Zgmanhui. All rights reserved.
//

#import "Target_share.h"
#import "MJShareManager.h"

@implementation Target_share

- (id)Action_simpleshare:(NSDictionary *)params {
    NSString *title = [params objectForKey:@"title"];
    NSString *content = [params objectForKey:@"content"];
    NSString *url = [params objectForKey:@"url"];
    NSString *imagesString = [params objectForKey:@"images"];
    [[MJShareManager sharedManager] showShareViewWithParams:@{@"generalOptions":@{
                                                                      @"title":title?title:@"",
                                                                      @"describe": content?content:@"",
                                                                      @"linkurl":url?url:@"",
                                                                      @"img": imagesString?imagesString:@""
                                                                    }
                                                              }];
    return nil;
}




- (id)Action_goodsshare:(NSDictionary *)params {
    NSString *subTitle = [params objectForKey:@"SubTitle"] ? [params objectForKey:@"SubTitle"] :  @"我在--网发现了一款很棒的商品，快来看！";
    NSString *img = [params objectForKey:@"LogImg"];
    NSString *goodsTitle = [params objectForKey:@"GoodsTitle"];
    NSNumber *SellPrice = [params objectForKey:@"SellPrice"];
    NSNumber *MarketPrice = [params objectForKey:@"MarketPrice"];
    NSString *shareUrl = [params objectForKey:@"ShareUrl"];
    
    NSString *sid = [params objectForKey:@"sid"];
    
    NSString *shareEventCallbackUrl = [params objectForKey:@"shareEventCallbackUrl"];
    [[MJShareManager sharedManager] showShareViewWithParams:@{
                                                              @"sid": sid?sid:@"",
                                                              @"shareEventCallbackUrl":shareEventCallbackUrl,
                                                              @"generalOptions":@{
                                                                      @"title":goodsTitle?goodsTitle:@"",
                                                                      @"describe": subTitle?subTitle:@"",
                                                                      @"linkurl": shareUrl?shareUrl:@"",
                                                                      @"img": img?img:@""
                                                                                  },
                                                              @"weiboOptions": @{
                                                                      @"describe":[NSString stringWithFormat:@"我在 @--网 发现了一款很棒的商品：%@  --价：￥%@。快来看！%@", goodsTitle ,SellPrice, shareUrl],
                                                                      @"img":img?img:@""
                                                                      },
                                                              @"QRCodeOptions": @{
                                                                      @"type": @1,
                                                                      @"img": img?img:@"" ,
                                                                      @"title": goodsTitle?goodsTitle:@"",
                                                                      @"price": SellPrice,
                                                                      @"originalPrice":MarketPrice,
                                                                      @"linkurl": shareUrl?shareUrl:@"",
                                                                      @"describe": subTitle
                                                                      },
                                                              @"SMSOptions": @{
                                                                      @"describe": [NSString stringWithFormat:@"%@%@", subTitle?subTitle:@"", shareUrl?shareUrl:@""]
                                                                      },
                                                              @"linkCopyOptions": @{
                                                                      @"linkurl": shareUrl?shareUrl:@""
                                                                      }
                                                              
                                                              }];
    return nil;
}


/** {
 "sid":"分享唯一标识符",
 "shareEventCallbackUrl":"分享事件回调url   用户点击一个选项之后 会调用一下这链接    仅支持GET请求，参数为shareIdentifier 和分享标识(上面定义的标识)  参数以url的形式上传",
 "generalOptions": {
 "describe": "标题和描述一个字段",
 "img": "图片",
 "linkurl": "跳转链接",
 "title": "分享标题"
 },
 "weiboOptions": {
 "title": "用于微博分享用的title",
 "img": "图片链接"
 },
 "QRCodeOptions": {
 "type": "二维码分享类型，0或者不传表示 通用的二维码分享类型  1：商品的二维码分享  2：商家分享类型",
 "img": "图片链接  多张图片逗号隔开 店铺分享时 需传入两张",
 "title": "标题",
 "price": "number 售价",
 "originalPrice": "number 原价",
 "linkurl": "链接  这里用于生成二维码",
 "shopLogo": "店铺logo   店铺分享时 必传",
 "shopCreditRating": "店铺信誉等级  店铺分享时 必传",
 "shopFans": "店铺粉丝数 店铺分享时 必传",
 "shopScore": "店铺评分 店铺分享时 必传"
 },
 "SMSOptions": {
 "describe": "短信分享内容"
 },
 "linkCopyOptions": {
 "linkurl": "用于复制的链接"
 }
 } */

- (id)Action_mjshare:(NSDictionary *)params {
    [[MJShareManager sharedManager] showShareViewWithParams:params];
    return nil;
}

- (id)Action_systemShare:(NSDictionary *)params {
    UIViewController *viewController = [params objectForKey:@"viewController"];
    NSString *title = [params objectForKey:@"title"];
    UIImage *image = [params objectForKey:@"image"];
    NSURL *url = [NSURL URLWithString:[params objectForKey:@"url"]];
    [[MJShareManager sharedManager] systemShareManagerWithViewController:viewController title:title image:image url:url];
    return nil;
}


@end
