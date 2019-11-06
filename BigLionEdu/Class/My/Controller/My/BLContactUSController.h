//
//  BLContactUSController.h
//  BigLionEdu
//
//  Created by OrangesAL on 2019/10/13.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "LCAlertController.h"

NS_ASSUME_NONNULL_BEGIN


@interface BLContactUSModel : NSObject

@property (nonatomic, copy)   NSString *content;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *createBy;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) NSString *updateBy;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, assign)   BOOL isQq;
@property (nonatomic, strong) NSString *createTime;

@end

@interface BLContactUSController : LCAlertController

@end

NS_ASSUME_NONNULL_END
