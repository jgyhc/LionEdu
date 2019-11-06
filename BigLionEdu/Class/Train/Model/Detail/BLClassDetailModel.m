//
//  BLClassDetailModel.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLClassDetailModel.h"

@implementation BLClassDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"liveRecCourseTypeDTOS" : [BLClassScheduleModel class],
             @"tutorDTOS": [BLClassDetailTeacherModel class]
    };
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

- (void)setStartEffectiveTime:(double)startEffectiveTime {
    _startEffectiveTime = startEffectiveTime;
    _startEffectiveTimeString = [self getMinuteTimeFromTimestampWithTime:startEffectiveTime format:@"YYYY.MM.dd"];
}

- (void)setEndEffectiveTime:(double)endEffectiveTime {
    _endEffectiveTime = endEffectiveTime;
    _endEffectiveTimeString = [self getMinuteTimeFromTimestampWithTime:endEffectiveTime format:@"YYYY.MM.dd"];
}

@end
