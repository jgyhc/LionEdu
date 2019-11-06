//
//  BLHomePageItemModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/21.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLHomePageItemModel : NSObject

/** content (string, optional): 内容 ,
 createBy (integer, optional),
 createTime (string, optional),
 delFlag (string, optional),
 id (integer, optional): id ,
 img (string, optional): 图片 ,
 pageNum (integer, optional),
 pageSize (integer, optional),
 sort (string, optional): 展示顺序 ,
 title (string, optional): 标题 ,
 updateBy (integer, optional),
 updateTime (string, optional)*/

@property (nonatomic, assign) NSInteger createBy;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *delFlag;

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *subTextColorSting;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *img;

@end

NS_ASSUME_NONNULL_END
