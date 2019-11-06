//
//  MJShareGlobalModel.h
//  MJShareKit_Example
//
//  Created by -- on 2019/1/10.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MJShareItemModel;
@interface MJShareGlobalModel : NSObject
/** 分享唯一标识符 */
@property (nonatomic, copy) NSString * sid;

/** "分享事件回调url   用户点击一个选项之后 会调用一下这链接    仅支持GET请求，参数为shareIdentifier 和分享标识(上面定义的标识)  参数以url的形式上传" */
@property (nonatomic, copy) NSString * shareEventCallbackUrl;

/** 通用分享实体 */
@property (nonatomic, strong) MJShareItemModel * generalOptions;

/** 二维码分享 */
@property (nonatomic, strong) MJShareItemModel * QRCodeOptions;

/** 短信分享 */
@property (nonatomic, strong) MJShareItemModel * SMSOptions;

/** 链接赋值 */
@property (nonatomic, strong) MJShareItemModel * linkCopyOptions;

/** 微博分享 */
@property (nonatomic, strong) MJShareItemModel * weiboOptions;


@end

@interface MJShareItemModel : NSObject


/** "二维码分享类型，0或者不传表示 通用的二维码分享类型  1：商品的二维码分享  2：商家分享类型" */
@property (nonatomic, assign) NSInteger type;

/** "图片链接  多张图片逗号隔开 店铺分享时 需传入两张" */
@property (nonatomic, copy) NSString * img;

/** images */
@property (nonatomic, strong) NSArray<UIImage *> * images;

/** "标题" */
@property (nonatomic, copy) NSString * title;

/** "链接  这里用于生成二维码" */
@property (nonatomic, copy) NSString * linkurl;

/** 描述 */
@property (nonatomic, copy) NSString * describe;

/** "number 售价" */
@property (nonatomic, strong) NSNumber * price;

/** "number 原价" */
@property (nonatomic, strong) NSNumber * originalPrice;

/** "店铺信誉等级  店铺分享时 必传" */
@property (nonatomic, strong) NSNumber * shopCreditRating;

/** "店铺logo   店铺分享时 必传" */
@property (nonatomic, copy) NSString * shopLogo;

/** "店铺粉丝数 店铺分享时 必传" */
@property (nonatomic, strong) NSNumber * shopFans;

/** "店铺评分 店铺分享时 必传" */
@property (nonatomic, strong) NSNumber * shopScore;

@end


NS_ASSUME_NONNULL_END
