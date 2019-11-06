//
//  BLGetTestPaperQuestionAPI.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "MJAPIBaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLGetTestPaperQuestionAPI : MJAPIBaseManager

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger functionTypeId;

@end

NS_ASSUME_NONNULL_END
