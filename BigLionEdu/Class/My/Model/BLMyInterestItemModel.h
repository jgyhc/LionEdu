//
//  BLMyInterestItemModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMyInterestItemModel : NSObject

@property (nonatomic, strong) NSArray *baseModels;

@property (nonatomic, strong) NSArray *myModels;

@end

@interface BLInterestInfoModel : NSObject
@property (nonatomic, assign)BOOL isSelected;
@property (nonatomic, strong)NSString *content; // (string, optional): 内容 ,
@property (nonatomic, strong)NSNumber *createBy; // (integer, optional),
@property (nonatomic, strong)NSString *createTime; // (string, optional),
@property (nonatomic, strong)NSString *delFlag; //(string, optional),
@property (nonatomic, assign)NSInteger modelid; //(integer, optional): id ,
@property (nonatomic, strong)NSString *img; //(string, optional): 图片 ,
@property (nonatomic, strong)NSString *memberIcon; //(string, optional): 图片 ,

@property (nonatomic, strong)NSNumber *pageNum;// (integer, optional),
@property (nonatomic, strong)NSNumber *pageSize;// (integer, optional),
@property (nonatomic, strong)NSString *sort;// (string, optional): 展示顺序 ,
@property (nonatomic, strong)NSString *title;// (string, optional): 标题 ,
@property (nonatomic, strong)NSNumber *updateBy;// (integer, optional),
@property (nonatomic, strong)NSString *updateTime;// (string, optional)

//BLInterestInfoModel
@end


NS_ASSUME_NONNULL_END
