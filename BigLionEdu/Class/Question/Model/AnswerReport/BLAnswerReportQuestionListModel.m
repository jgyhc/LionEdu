//
//  BLAnswerReportQuestionListModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLAnswerReportQuestionListModel.h"

@implementation BLAnswerReportQuestionListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"liveRecDTOList" : [BLAnswerReportQuestionItemModel class]};
}

@end


@implementation BLAnswerReportQuestionItemModel

- (void)setCoverImg:(NSString *)coverImg {
    _coverImg = [NSString stringWithFormat:@"%@%@", IMG_URL, coverImg];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
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

- (void)setLiveEndDateLog:(NSInteger)liveEndDateLog {
    _liveEndDateLog = liveEndDateLog;
    _endTimeString = [self getMinuteTimeFromTimestampWithTime:liveEndDateLog format:@"YYYY.MM.dd"];
}

- (void)setLiveStartDateLog:(NSInteger)liveStartDateLog {
    _liveStartDateLog = liveStartDateLog;
    _startTimeString = [self getMinuteTimeFromTimestampWithTime:liveStartDateLog format:@"YYYY.MM.dd"];
}
@end
