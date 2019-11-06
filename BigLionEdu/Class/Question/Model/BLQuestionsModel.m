//
//  BLQuestionsModel.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/16.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLQuestionsModel.h"
#import <UIKit/UIKit.h>

@interface BLQuestionsModel ()

@property (nonatomic, strong) NSAttributedString *eachPriceString;

@end

@implementation BLQuestionsModel

//- (void)setImg:(NSString *)img {
//    _img = [NSString stringWithFormat:@"%@%@", IMG_URL, img];
//}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @"id"};
}

- (void)setEffectiveTime:(double)effectiveTime {
    _effectiveTime = effectiveTime;
    _effectiveTimeString = [self getMinuteTimeFromTimestampWithTime:effectiveTime format:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)setStartEffectiveTime:(double)startEffectiveTime {
    _startEffectiveTime = startEffectiveTime;
    _startEffectiveTimeString = [self getMinuteTimeFromTimestampWithTime:startEffectiveTime format:@"yyyy-MM-dd"];
}

- (void)setEndEffectiveTime:(double)endEffectiveTime {
    _endEffectiveTime = endEffectiveTime;
    _endEffectiveTimeString = [self getMinuteTimeFromTimestampWithTime:endEffectiveTime format:@"yyyy-MM-dd"];
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


- (NSAttributedString *)priceAttString {
    if (!_priceAttString) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@""];
        if ([_isPurchase isEqualToString:@"1"] || _isAllBuy) {//已经购买
            if ([_isAdvance isEqualToString:@"1"] && !_isStart) {
                [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@发放试卷)", _advanceDate] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0 green:185/255.0 blue:0.00/255.0 alpha:1.0]}]];
            }else {
                [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"有效时间：%@-%@", _startEffectiveTimeString, _endEffectiveTimeString] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0 green:185/255.0 blue:0.00/255.0 alpha:1.0]}]];
            }
        }else {
            if ([_isAdvance isEqualToString:@"1"]) {
                [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"预售￥%0.2f", [_price doubleValue]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.00/255.0 alpha:1.0]}]];
                if (!_isStart) {
                    [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@发放试卷)", _advanceDate] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0 green:185/255.0 blue:0.00/255.0 alpha:1.0]}]];
                }
            }else {
                if ([_price doubleValue] > 0) {
                    [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%0.2f", [_price doubleValue]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.00/255.0 alpha:1.0]}]];
                    if (_eachPriceString) {
                        [att appendAttributedString:_eachPriceString];
                    }
                }
            }
           
        }
        _priceAttString = att;
    }
    return _priceAttString;
}

- (void)setEachPrice:(NSNumber *)eachPrice {
    _eachPrice = eachPrice;
    if (![_isPurchase isEqualToString:@"1"]) {
//        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"￥" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W03" size:12],NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.00/255.0 alpha:1.0]}]];
//        [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.2f", [_price doubleValue]] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W03" size:15],NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.00/255.0 alpha:1.0]}]];
//
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(￥%0.2f/套)", [_eachPrice doubleValue]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.00/255.0 alpha:1.0]}]];
        _eachPriceString = att;
//        _priceAttString = att;
    }
}

@end
