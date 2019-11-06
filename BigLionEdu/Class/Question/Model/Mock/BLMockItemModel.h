//
//  BLMockItemModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMockItemModel : NSObject
/** testId    int    模考id
setId    int    试卷id
title    string    模考标题
registerNum    int    报名人数
countdown    int    倒计时时间限制，单位为分钟
liveImg    string    大狮解背景图片
img    string    模考背景图片
testRule    string    考试规则
status    string    模考状态：1.未报名、2、已报名、3、已考试
startDate    date    模考大赛开始时间
endDate    date    模考大赛结束时间
startDateLog    long    模考大赛开始时间-时间戳
endDateLog    long    模考大赛结束时间-时间戳
liveId    int    直播考试ID， 如果错过时间，则为录播id
liveStartDateLog    long    模考大赛结束时间-时间戳
liveEndDateLog    long    模考大赛结束时间-时间戳
isFree    string    是否免费：1.是 0.否
isManual    string    是否需要人工干预 1.是 0.否
isRare    string    是否稀罕：1:稀罕， 0：不是 */


@property (nonatomic, copy)   NSString *testRule;
@property (nonatomic, assign) NSInteger countdown;
@property (nonatomic, strong) NSString *liveEndDateLog;
@property (nonatomic, copy)   NSString *isManual;
@property (nonatomic, strong) NSString *liveStartDateLog;
@property (nonatomic, copy)   NSString *liveImg;
@property (nonatomic, assign) double endDateLog;
@property (nonatomic, copy)   NSString *img;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) NSInteger testId;
@property (nonatomic, assign) NSInteger setId;
@property (nonatomic, copy)   NSString *endTime;

@property (nonatomic, copy) NSString * duration;

/** 模考大赛开始时间-时间戳 */
@property (nonatomic, assign) double startDateLog;
@property (nonatomic, assign) NSInteger liveId;
@property (nonatomic, copy)   NSString *isRare;
@property (nonatomic, assign) NSInteger registerNum;
@property (nonatomic, copy)   NSString *startTime;

/** status    string    模考状态：1.未报名、2、已报名、3、已考试 */
@property (nonatomic, copy)   NSString *status;
@property (nonatomic, copy)   NSString *isFree;


@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, copy) NSString *liveTimeSting;

@property (nonatomic, assign) NSInteger timeStatus;

@property (nonatomic, assign) NSTimeInterval timeDifference;

@property (nonatomic, strong) NSDate * benginDate;
//0未到提醒时间  1 到了提醒时间了  2 已经开始了
- (void)getCurrentDateState;

- (NSString *)getMinuteTimeFromTimestampWithTime:(double)time format:(NSString *)format;

@property (nonatomic, assign) BOOL isCanSignUp;
@end

NS_ASSUME_NONNULL_END
