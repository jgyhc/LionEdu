//
//  BLMockItemModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLMockItemModel.h"

@interface BLMockItemModel ()

@property (nonatomic, strong) NSDate * remindDate;




@end

@implementation BLMockItemModel

- (NSString *)timeString {
    return [NSString stringWithFormat:@"%@-%@", [self getTimeFromTimestampWithTime:_startDateLog], [self getMinuteTimeFromTimestampWithTime:_endDateLog]];
}

- (NSString *)liveTimeSting {
    if (!_liveTimeSting) {
        _liveTimeSting = [NSString stringWithFormat:@"%@-%@", [self getTimeFromTimestampWithTime:[_liveStartDateLog doubleValue]], [self getMinuteTimeFromTimestampWithTime:[_liveEndDateLog doubleValue]]];
    }
    return _liveTimeSting;
}

- (NSString *)getTimeFromTimestampWithTime:(double)time {
    return [self getMinuteTimeFromTimestampWithTime:time format:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)getMinuteTimeFromTimestampWithTime:(double)time {
    return [self getMinuteTimeFromTimestampWithTime:time format:@"HH:mm"];
}

- (NSString *)getMinuteTimeFromTimestampWithTime:(double)time format:(NSString *)format {
    NSDate * myDate = [self stringToDateWithTime:time];
    //设置时间格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:myDate];
    return timeStr;
}

- (NSDate *)stringToDateWithTime:(double)time {
    NSTimeInterval interval = time / 1000.0;
    //将对象类型的时间转换为NSDate类型
    return [NSDate dateWithTimeIntervalSince1970:interval];
}


- (void)setStartDateLog:(double)startDateLog {
    _startDateLog = startDateLog;
    //开始时间
    _benginDate = [self stringToDateWithTime:startDateLog];
}

- (void)getMockRemindDate {
    //获取提醒的时间
    NSTimeInterval s = 60 * _countdown;
    _remindDate = [_benginDate initWithTimeIntervalSinceNow:-s];
}

//0未到提醒时间  1 到了提醒时间了  2 已经开始了
- (void)getCurrentDateState {
    [self getMockRemindDate];
    NSTimeInterval current = [self currentTimeStr:[NSDate date]];
    NSTimeInterval remind = [self currentTimeStr:_remindDate];
    NSTimeInterval bengin = [self currentTimeStr:_benginDate];
    if (current < remind) {
        _timeStatus = 0;
    }else if (current > bengin) {
        _timeStatus =  2;
    }else {
        _timeStatus =  1;
    }
}

- (NSTimeInterval)currentTimeStr:(NSDate *)date {
    NSTimeInterval time = [date timeIntervalSince1970];
    return time;
}

- (void)setImg:(NSString *)img {
    _img = [NSString stringWithFormat:@"%@%@", IMG_URL, img];
}

- (void)setLiveImg:(NSString *)liveImg {
    _liveImg = [NSString stringWithFormat:@"%@%@", IMG_URL, liveImg];
}

- (NSTimeInterval)timeDifference {
    return [[NSDate date] timeIntervalSinceDate:_benginDate];
}

- (BOOL)isCanSignUp {
    if (![_status isEqualToString:@"1"]) {
        return NO;
    }
    NSTimeInterval current = [self currentTimeStr:[NSDate date]];
    NSTimeInterval bengin = [self currentTimeStr:_benginDate];
    if (current >= bengin) {
        return NO;
    }
    return YES;
}

@end
