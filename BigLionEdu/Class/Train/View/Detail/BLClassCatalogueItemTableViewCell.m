//
//  BLClassCatalogueItemTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLClassCatalogueItemTableViewCell.h"

@interface BLClassCatalogueItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) BLClassScheduleItemModel *item;

@end

@implementation BLClassCatalogueItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NSArray *)model {
    _model = model;
    BLClassScheduleItemModel *obj = model.firstObject;
    _item = obj;
    _titleLabel.text = obj.liveRecCourseTitle;
    _subTitleLabel.text = [NSString stringWithFormat:@"%ld分钟", obj.hours];
    if (obj.playerStatus == 1) {
        _playerImageView.hidden = NO;
        _containerView.hidden = YES;
    } else {
        _playerImageView.hidden = YES;
        _containerView.hidden = NO;
        if (obj.playerStatus == 0) {
//            _topImageView.image = [UIImage imageNamed:@"kcxq_bfz"];
//            _bottomLabel.text = @"";
        }
    }
    BLClassDetailModel *detail = model[1];
    //    课程类型 ：0：直播， 1：录播，2：课程， 3：狮享
    if (detail.type != 0) {
        self.containerView.hidden = NO;
        self.playerImageView.hidden = NO;
        self.bottomLabel.hidden = YES;
        self.playerImageView.image = [UIImage imageNamed:@"bl_pl"];
    }
    
}


- (void)startTime {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:self.model.timeDifference];
    dispatch_source_set_event_handler(timer, ^{
        int interval = [self.item.startDate timeIntervalSinceNow];
        if (interval <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.bottomLabel.text = @"";
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.bottomLabel.text = [NSString stringWithFormat:@"倒计时:%@", [self getMMSSFromSS:[@(interval) stringValue]]];
            });
        }
    });
    dispatch_resume(timer);
}

//传入 秒  得到 xx:xx:xx
- (NSString *)getMMSSFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}


@end
