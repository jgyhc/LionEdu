//
//  BLGetAllModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/9/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLGetAllModel : NSObject
@property (nonatomic, copy)   NSString *sort;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) NSInteger updateBy;
@property (nonatomic, copy)   NSString *createTime;

@property (nonatomic, assign) BOOL selected;
@end

NS_ASSUME_NONNULL_END
