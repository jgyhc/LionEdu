//
//  BLTrainCoreNewsModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTrainCoreNewsModel : NSObject
/** content (string, optional): 头条内容 ,
 createBy (integer, optional),
 createTime (string, optional),
 delFlag (string, optional),
 id (integer, optional),
 isHot (string, optional): 是否热门1:hot, 0: not hot ,
 isImportant (string, optional): 是否重要（0否 1是） ,
 isTop (string, optional): 是否置顶（0否 1是） ,
 pageNum (integer, optional): 页码 ,
 pageSize (integer, optional): 页数 ,
 title (string, optional): 头条名称 ,
 typeId (integer, optional): 类型Id ,
 updateBy (integer, optional),
 updateTime (string, optional) */
@property (nonatomic, assign) NSInteger createBy;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, assign) NSInteger  isHot;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, assign) NSInteger updateBy;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, copy)   NSString *isImportant;
@property (nonatomic, copy)   NSString *isTop;
@property (nonatomic, copy)   NSString *content;

@property (nonatomic, strong) NSAttributedString *titleString;

@end

NS_ASSUME_NONNULL_END
