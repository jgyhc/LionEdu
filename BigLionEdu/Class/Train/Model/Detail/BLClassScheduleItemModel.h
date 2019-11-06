//
//  BLClassScheduleItemModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLClassScheduleItemModel : NSObject

@property (nonatomic, assign) NSInteger liveRecId;
@property (nonatomic, strong) NSString *liveEndDateLog;
@property (nonatomic, strong) NSString *liveEndDate;
@property (nonatomic, assign) NSInteger isDdownload;
@property (nonatomic, strong) NSString *liveStartDateLog;
@property (nonatomic, assign) NSInteger hours;
@property (nonatomic, copy)   NSString *noteLocation;
@property (nonatomic, copy)   NSString *oldFileName;
@property (nonatomic, copy)   NSString *liveRecCourseTitle;
@property (nonatomic, strong) NSString *liveStartDate;

//0还未开始  1正在播放  2播放过了
@property (nonatomic, assign) NSInteger playerStatus;

@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
