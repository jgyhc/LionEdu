//
//  BLTrainModuleBannersModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainModuleBannersModel : NSObject
/** createBy (integer, optional),
 createTime (string, optional),
 delFlag (string, optional),
 id (integer, optional): id ,
 img (string, optional): 图片 ,
 module_id (integer, optional): 模块id ,
 sort (string, optional): 展示顺序 ,
 title (string, optional): 标题 ,
 type (string, optional): 类型 1：首页详情页轮播图, 2:商品轮播图 ,
 updateBy (integer, optional),
 updateTime (string, optional),
 url (string, optional): 图片地址 */

@property (nonatomic, strong) NSNumber * Id;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, strong) NSNumber * module_id;
@property (nonatomic, strong) NSNumber * updateBy;
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, copy)   NSString *img;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, copy)   NSString *sort;
@property (nonatomic, strong) NSNumber * createBy;


@end

NS_ASSUME_NONNULL_END
