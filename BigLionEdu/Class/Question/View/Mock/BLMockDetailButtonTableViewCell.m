//
//  BLMockDetailButtonTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLMockDetailButtonTableViewCell.h"

@interface BLMockDetailButtonTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, strong) CAGradientLayer *gl;
@end

@implementation BLMockDetailButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_button setBackgroundColor:[UIColor clearColor]];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 30, 37);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:217/255.0 blue:120/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0].CGColor];
    gl.cornerRadius = 18.5;
    gl.locations = @[@(0.0), @(0.8), @(1.0)];
    _gl = gl;
    [_button.layer addSublayer:gl];
    [_button.layer insertSublayer:gl atIndex:0];
    [_button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)handleEvent:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectButtonWithModel:)]) {
        [self.delegate didSelectButtonWithModel:_model];
    }
}

- (void)setModel:(BLMockItemModel *)model {
    _model = model;
    /** 开始考试那个时间，开始倒计时，那个倒计时字段是用来倒计时提醒的，比如2019-09-28 10:30 开始考试，倒计时60分钟，那么你就要9点30分开始倒计时 */
    /** 模考状态：1.未报名、2、已报名、3、已考试 */
    if ([model.status isEqualToString:@"2"]) {
        ////0未到提醒时间  1 到了提醒时间了  2 已经开始了
        if (model.timeStatus == 0) {
            [_button setBackgroundColor:[UIColor colorWithRed:242/255.0 green:243/255.0 blue:247/255.0 alpha:1.0]];
            [_button setTitle:@"等待考试" forState:UIControlStateNormal];
            [_button setTitleColor:[UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0] forState:UIControlStateNormal];
            _gl.colors = @[(__bridge id)[UIColor colorWithRed:242/255.0 green:243/255.0 blue:247/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:242/255.0 green:243/255.0 blue:247/255.0 alpha:1.0].CGColor];
        }else if (model.timeStatus == 1) {
            [self startTime];
            [_button setBackgroundColor:[UIColor colorWithRed:242/255.0 green:243/255.0 blue:247/255.0 alpha:1.0]];
            [_button setTitleColor:[UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0] forState:UIControlStateNormal];
            _gl.colors = @[(__bridge id)[UIColor colorWithRed:242/255.0 green:243/255.0 blue:247/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:242/255.0 green:243/255.0 blue:247/255.0 alpha:1.0].CGColor];
        }else {
            [_button setTitle:@"立即考试" forState:UIControlStateNormal];
            [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:217/255.0 blue:120/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0].CGColor];
        }
    }
}



- (void)startTime {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:self.model.timeDifference];
    dispatch_source_set_event_handler(timer, ^{
        int interval = [self.model.benginDate timeIntervalSinceNow];
        if (interval <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.button setTitle:@"立即考试" forState:UIControlStateNormal];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.button setTitle:[NSString stringWithFormat:@"考试倒计时:%@", [self getMMSSFromSS:[@(interval) stringValue]]] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(timer);
}

//传入 秒  得到 xx:xx:xx
- (NSString *)getMMSSFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}


@end
