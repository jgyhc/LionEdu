//
//  BLMyCollectModel.h
//  BigLionEdu
//
//  Created by mac on 2019/9/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMyCollectTypeDotsModel : NSObject
@property (nonatomic, assign) NSInteger functionId;// (integer, optional): 功能Id ,
@property (nonatomic, assign) NSInteger modelid;// (integer, optional): 模块功能类型id ,
@property (nonatomic, copy) NSString *isDaily;// (string, optional): 每日一练:Y, 其他为N ,
@property (nonatomic, copy) NSString *isTest;// (string, optional): 1: 模考大赛，0：其他 ,
@property (nonatomic, assign) NSInteger modelId;// (integer, optional): 模块id ,
@property (nonatomic, copy) NSString *sort;// (string, optional): 展示顺序 ,
@property (nonatomic, copy) NSString *title;// (string, optional): 标题 ,
@property (nonatomic, copy) NSString *type;// (string, optional): 类型 1:题库，2：直播，3：录播，4：狮享等等
@end

@interface BLMyCollectTypeModel : NSObject
@property (nonatomic, copy) NSString *content;// (string, optional): 内容 ,
@property (nonatomic, copy) NSArray <BLMyCollectTypeDotsModel *>*functionTypeErrorDTOS;//(Array[KylinIndexFunctionTypeErrorDTO], optional): 题模块功能类型 ,
@property (nonatomic, assign)NSInteger modelid;// (integer, optional): id ,
@property (nonatomic, copy) NSString *img;// (string, optional): 图片 ,
@property (nonatomic, copy) NSString *sort;// (string, optional): 展示顺序 ,
@property (nonatomic, copy) NSString *title;// (string, optional): 标题
@end


NS_ASSUME_NONNULL_END
