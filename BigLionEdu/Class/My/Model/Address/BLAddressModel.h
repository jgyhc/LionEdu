//
//  BLAddressModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLAddressModel : NSObject
/** city (string, optional): 市 ,
 createBy (integer, optional),
 createTime (string, optional),
 delFlag (string, optional),
 detail (string, optional): 详细地址 ,
 district (string, optional): 区 ,
 id (integer, optional),
 isDefault (string, optional): 默认标识 ,
 memberId (integer, optional): 用户ID ,
 mobile (string, optional): 电话 ,
 name (string, optional): 姓名 ,
 province (string, optional): 省份 ,
 updateBy (integer, optional),
 updateTime (string, optional),
 zipcode (string, optional): 邮政编码 */

@property (nonatomic, copy)   NSString *detail;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy)   NSString *mobile;
@property (nonatomic, copy)   NSString *province;
@property (nonatomic, copy)   NSString *isDefault;
@property (nonatomic, copy)   NSString *zipcode;
@property (nonatomic, copy)   NSString *city;
@property (nonatomic, copy)   NSString *district;
@property (nonatomic, copy)   NSString *name;


#pragma mark -- custom
@property (nonatomic, assign) BOOL selected;
@end

NS_ASSUME_NONNULL_END
