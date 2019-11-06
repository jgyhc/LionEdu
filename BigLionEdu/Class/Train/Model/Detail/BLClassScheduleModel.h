//
//  BLClassScheduleModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLClassScheduleItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLClassScheduleModel : NSObject
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *courseLiveStartDate;
@property (nonatomic, strong) NSString *courseLiveStartDateLog;
@property (nonatomic, strong) NSString *courseLiveEndDate;
@property (nonatomic, strong) NSArray<BLClassScheduleItemModel *> *liveRecCourseDTOS;
@property (nonatomic, strong) NSString *courseLiveEndDateLog;
@property (nonatomic, copy)   NSString *courseTitle;
@property (nonatomic, assign) NSInteger totalHours;

@property (nonatomic, assign) BOOL isOpen;
@end

NS_ASSUME_NONNULL_END
