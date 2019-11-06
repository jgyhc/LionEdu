//
//  Target_share.h
//  ManJi
//
//  Created by -- on 2018/12/21.
//  Copyright © 2018 Zgmanhui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_share : NSObject


/**
 简单分享

 @param params @{
 @"url":
 @"title":
 @"content":
 @"images":"UIImage的数组  或则   NSString的数组"
 }
 @return nil
 */
- (id)Action_simpleshare:(NSDictionary *)params;

/** @{
 @"GoodsTitle":
 @"SubTitle":
 @"ShareUrl":
 @"SellPrice"：
 @"LogImg":
 @"ID":
 @"ShopLogo"
 } */
- (id)Action_goodsshare:(NSDictionary *)params;



/** {
 "sid":"分享唯一标识符",
 "shareEventCallbackUrl":"分享事件回调url   用户点击一个选项之后 会调用一下这链接    仅支持GET请求，参数为shareIdentifier 和分享标识(上面定义的标识)  参数以url的形式上传",
 "generalOptions": {
 "describe": "标题和描述一个字段",
 "img": "图片",
 "linkurl": "跳转链接",
 "title": "分享标题"
 }
 }
 */
- (id)Action_mjshare:(NSDictionary *)params;


@end

NS_ASSUME_NONNULL_END
