//
//  BLNewsDTOListModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/3.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLNewsDTOListModel : NSObject

/** id    int    类型id
title    string    类型名称
modelId    int    模块Id
newsDTOList—> id    int    头条id
newsDTOList—> title    string    头条名称
newsDTOList—> content    string    头条内容
newsDTOList—> enclosure    string    附件名称
newsDTOList—> oldPath    string    附件源文件名称
newsDTOList—> isHot    string    是否热门1:hot, 0: not hot
newsDTOList—> isTop    string    是否置顶（0否 1是）
newsDTOList—> isImportant    string    是否重要（0否 1是） */
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy)   NSString *isHot;
@property (nonatomic, assign) NSInteger createBy;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, assign) NSInteger updateBy;
@property (nonatomic, copy)   NSString *oldPath;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, copy)   NSString *enclosure;
@property (nonatomic, copy)   NSString *isImportant;
@property (nonatomic, copy)   NSString *isTop;
@property (nonatomic, copy)   NSString *content;
@end

NS_ASSUME_NONNULL_END
