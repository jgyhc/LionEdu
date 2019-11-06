//
//  BLPaperModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLPaperModel.h"
#import <UIKit/UIKit.h>
#import <YYText.h>
#import "NSMutableAttributedString+BLTextBorder.h"

@implementation BLPaperModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @"id"};
}

- (void)setGoodsId:(NSInteger)goodsId {
    _goodsId = goodsId;
}

- (void)setId:(NSInteger)Id {
    _Id = Id;
}

- (void)setPrice:(NSNumber *)price {
    _price = price;
}

- (NSMutableAttributedString *)titleAttributeString {
    if (!_titleAttributeString) {
        UIColor *textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        if ([_isAdvance isEqualToString:@"1"] && !_isStart) {//是预售卷子
            textColor = [UIColor colorWithRed:207/255.0 green:214/255.0 blue:230/255.0 alpha:1.0];
        }
        
        if ([_isRare isEqualToString:@"1"]) {
            NSMutableAttributedString *att = [NSMutableAttributedString initText:@"稀罕" textColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0] font:[UIFont systemFontOfSize:12]  strokeColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0] fillColor:[UIColor clearColor] cornerRadius:3 strokeWidth:1 insets:UIEdgeInsetsMake(0, -5.5, 0, -5)];
            _tagAttributeString = att;
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:_title?_title:@""];
            
            title.yy_font = [UIFont systemFontOfSize:15];
            title.yy_color = textColor;
            _titleContentAttributeString = title;
            [att yy_appendString:@"  "];
            [att appendAttributedString:title];
            _titleAttributeString = att;
        }else {
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:_title?_title:@""];
            title.yy_font = [UIFont systemFontOfSize:15];
            title.yy_color = textColor;
            _titleAttributeString = title;
        }
    }
    return _titleAttributeString;
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

- (void)setStartEffectiveTime:(long)startEffectiveTime {
    _startEffectiveTime = startEffectiveTime;
    _startEffectiveTimeString = [self getMinuteTimeFromTimestampWithTime:startEffectiveTime format:@"YYYY.MM.dd"];
}

- (void)setEndEffectiveTime:(long)endEffectiveTime {
    _endEffectiveTime = endEffectiveTime;
    _endEffectiveTimeString = [self getMinuteTimeFromTimestampWithTime:endEffectiveTime format:@"YYYY.MM.dd"];
}

- (void)setAdvanceDate:(NSString *)advanceDate {
    _advanceDate = advanceDate;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *adDate = [formatter dateFromString:advanceDate];
    NSTimeInterval adInterval = [self currentTimeStr:adDate];
    NSTimeInterval currentInterval = [self currentTimeStr:[NSDate date]];
    if (adInterval < currentInterval) {
        _isStart = YES;
    }
}

- (NSTimeInterval)currentTimeStr:(NSDate *)date {
    NSTimeInterval time = [date timeIntervalSince1970];
    return time;
}

@end
