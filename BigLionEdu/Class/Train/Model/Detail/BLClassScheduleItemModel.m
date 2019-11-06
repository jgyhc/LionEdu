//
//  BLClassScheduleItemModel.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLClassScheduleItemModel.h"
#import <YYModel.h>

@implementation BLClassScheduleItemModel

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

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

//0还未开始  1正在播放  2播放过了
- (NSInteger)playerStatus {
    NSInteger endStatus = [self compareDate:[NSDate date] withDate:_endDate];
    if (endStatus == -1) {//直播完了
        _playerStatus = 2;
    }else {
        NSInteger startStatus = [self compareDate:[NSDate date] withDate:_startDate];
        if (startStatus == 1) {//
            _playerStatus = 1;
        }else {
            _playerStatus = 0;
        }
    }
    return _playerStatus;
}

- (NSInteger)compareDate:(NSDate*)aDate withDate:(NSDate*)bDate {
    NSComparisonResult result = [aDate compare:bDate];
    if (result == NSOrderedDescending) {
        return 1;
    }else if(result ==NSOrderedAscending){
        //指定时间 没过期
        return -1;
    }else{
        return 0;
    }
}

- (void)setLiveStartDateLog:(NSString *)liveStartDateLog {
    _liveStartDateLog = liveStartDateLog;
    _startDate = [self stringToDateWithTime:[liveStartDateLog doubleValue]];
}

- (void)setLiveEndDateLog:(NSString *)liveEndDateLog {
    _liveEndDateLog = liveEndDateLog;
    _endDate = [self stringToDateWithTime:[liveEndDateLog doubleValue]];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
}

@end
