//
//  BLAreaManager.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/17.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLAreaModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLAreaManager : NSObject

+ (instancetype)sharedInstance;

- (void)startRequestArea;

@property (nonatomic, strong, readonly) NSArray<BLAreaModel *> * areaList;


@property (nonatomic, strong) BLAreaModel * provinceAreaModel;

@property (nonatomic, strong) BLAreaModel * cityAreaModel;

@property (nonatomic, strong) BLAreaModel * areaAreaModel;
@end

NS_ASSUME_NONNULL_END
