//
//  BLRecordItemTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLRecordItemTableViewCell.h"

@interface BLRecordItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *goanwserBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@end

@implementation BLRecordItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLMyRecordDTOListModel *)model {
    _titleLabel.text = model.title;
//    已完成 20/80   ▏用时30分钟
    
    _goanwserBtn.hidden = model.status == 1;
    
    if (model.status == 1) {

//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.completeTime.integerValue];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy.MM.dd"];
//        NSString *complete = [formatter stringFromDate:date];
//        
//        _infoLabel.text = [NSString stringWithFormat:@"用时%ld分钟   ▏考试成绩：%@   ▏%@完成", model.useDuration, model.score, complete];
        _infoLabel.text = [NSString stringWithFormat:@"用时%@   ▏考试成绩：%@   ▏%@完成", [self getMMSSFromSS:model.useDuration], model.score, [self getMinuteTimeFromTimestampWithTime:[model.completeTime doubleValue] format:@"YYYY.MM.dd"]];
    }else {
        _infoLabel.text = [NSString stringWithFormat:@"已完成 %ld/%ld   ▏用时%@", (long)model.doneCount, (long)model.total, [self getMMSSFromSS:model.useDuration]];
    }
}

//传入 秒  得到  xx分钟xx秒
- (NSString *)getMMSSFromSS:(NSInteger )seconds {
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
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

@end
