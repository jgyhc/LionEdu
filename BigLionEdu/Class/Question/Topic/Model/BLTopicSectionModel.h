//
//  BLTopicSectionModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/24.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLTopicSectionModel : NSObject

@property (nonatomic, strong) NSMutableArray * topicList;

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString * classfierType;

@property (nonatomic, assign) NSInteger totalNum;

@end

NS_ASSUME_NONNULL_END
