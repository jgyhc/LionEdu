//
//  BLAnswerReportModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/25.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLAnswerReportModel.h"

@implementation BLAnswerReportModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
                @"cassfierDTOList" : [BLAnswerReportCassfierModel class]
             };
}

- (void)setDuration:(NSInteger)duration {
    _duration = duration;
    _time = [self getMMSSFromSS:[@(duration) stringValue]];
}

- (NSString *)getMMSSFromSS:(NSString *)totalTime {
    NSInteger seconds = [totalTime integerValue];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

@end

@implementation BLAnswerReportCassfierModel

- (void)setUsedTime:(NSInteger)usedTime {
    _usedTime = usedTime;
    _time = [self getMMSSFromSS:[@(usedTime) stringValue]];
}

- (NSString *)getMMSSFromSS:(NSString *)totalTime {
    NSInteger seconds = [totalTime integerValue];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

@end
