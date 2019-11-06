//
//  BLModuleSingleton.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLHomePageItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLModuleSingleton : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSArray<BLHomePageItemModel *> * modules;


@property (nonatomic, strong) NSMutableArray *titles;
@end

NS_ASSUME_NONNULL_END
