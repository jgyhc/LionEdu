//
//  BLIndexTestModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLIndexTestModel : NSObject

@property (nonatomic, copy)   NSString *content;
@property (nonatomic, copy)   NSString *img;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) NSInteger createBy;
@property (nonatomic, assign) NSInteger updateBy;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, copy)   NSString *createTime;
@end

NS_ASSUME_NONNULL_END
