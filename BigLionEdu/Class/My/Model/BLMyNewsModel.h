//
//  BLMyNewsModel.h
//  BigLionEdu
//
//  Created by sunmaomao on 2019/9/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMyNewsModel : NSObject
@property (nonatomic, copy) NSString *content;// (string, optional): 内容 ,
//id (integer, optional),
@property (nonatomic, assign) NSInteger memberId;// (integer, optional): 会员ID ,
@property (nonatomic, assign) NSInteger messageTypeId;// (integer, optional): 消息类型ID ,
@property (nonatomic, copy) NSString *title;// (string, optional): 标题
@end

@interface BLMyNewsTypeModel : NSObject
@property (nonatomic, copy) NSString *customDescription;// (string, optional): 描述 ,
@property (nonatomic, copy) NSString *icon;// (string, optional): 消息类型图标 ,
@property (nonatomic, assign) NSInteger Id;// (integer, optional),
@property (nonatomic, assign) NSInteger parentId;// (integer, optional): 父级ID ,
@property (nonatomic, copy) NSString *title;// (string, optional): 标题 ,
@property (nonatomic, copy) NSString *value;// (string, optional): 值

//@property (nonatomic, copy) NSString *content;// (string, optional): 内容 ,
////id (integer, optional),
//@property (nonatomic, assign) NSInteger memberId;// (integer, optional): 会员ID ,
//@property (nonatomic, assign) NSInteger messageTypeId;// (integer, optional): 消息类型ID ,
//@property (nonatomic, copy) NSString *title;// (string, optional): 标题
@end

NS_ASSUME_NONNULL_END
