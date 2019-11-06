//
//  BLAreaModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/17.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BLAreaModel;
@interface BLAreaModel : NSObject

@property (nonatomic, assign) NSInteger areaId;

@property (nonatomic, copy) NSString * areaName;

@property (nonatomic, assign) NSInteger areaParentId;

@property (nonatomic, strong) NSMutableArray<BLAreaModel *> * subAreas;


//如果是二级或者三级 会有值
@property (nonatomic, copy) NSString *provinceString;
@property (nonatomic, assign) NSInteger provinceId;

//如果是三级 会有值
@property (nonatomic, copy) NSString *cityString;
@property (nonatomic, assign) NSInteger cityId;




@end

NS_ASSUME_NONNULL_END
