//
//  BLGoodsGroupCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/5.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGoodsGroupCell.h"
#import <SDWebImage.h>
#import "NTCatergory.h"

@interface BLGoodsGroupCell ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation BLGoodsGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.joinBtn setBackgroundImage:[UIImage imageNamed:@"cart_sbg"] forState:UIControlStateNormal];
    [self.joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinBtn setBackgroundImage:[UIImage imageNamed:@"cart_xbg"] forState:UIControlStateSelected];
    [self.joinBtn setTitleColor:[UIColor nt_colorWithHexString:@"#FF6B00"] forState:UIControlStateSelected];
    [self.joinBtn addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
    [self.joinBtn setTitle:@"参加拼团" forState:UIControlStateNormal];
    [self.joinBtn setTitle:@"邀请好友" forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        _timer = nil;
    }
}

- (void)join {
    [self.delegate BLGoodsGroupCellJoinGroup:self.model];
}

- (void)setModel:(BLGoodsDetailGroupModel *)model {
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:model.photo?:@""]] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
    self.nameLab.text = model.nickname;
    self.endTimeLab.text = [NSString stringWithFormat:@"还差%@人，结束时间：%@", model.needMemberNum, model.endTime];
    if ([model.groupType isEqualToString:@"参加拼团"]) {
        self.joinBtn.selected = NO;
    } else {
        self.joinBtn.selected = YES;
    }
    [self downSecondHandle:model.endTime];
}

-(void)downSecondHandle:(NSString *)endDateString{

    NSDate *endDate = [NSDate nt_dateWithString:endDateString format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [NSDate date];
    NSTimeInterval timeInterval =[endDate timeIntervalSinceDate:startDate];
    if (timeInterval <= 0) {
        self.endTimeLab.text = [NSString stringWithFormat:@"还差%@人，团购已结束", self.model.needMemberNum];
        self.model.isEnd = YES;
        return;
    }
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        __block int count = 0;
        __block NSString *times = @"00:00:00.00";
        __block NSString *ds;
        __block NSString *hs;
        __block NSString *ms;
        __block NSString *ss;
        __weak typeof(self) wself = self;
        if (timeout!=0) {

            dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.01 *NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0) { //倒计时结束，关闭
                    dispatch_source_cancel(wself.timer);
                    wself.timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //倒计时结束的时候更新UI
                    });
                } else {
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    count += 1;
                    if (count > 99) {
                        count = 1;
                        timeout--;
                        if (days > 0) {
                            ds = [NSString stringWithFormat:@"%d天", days];
                        } else {
                            ds = @"";
                        }
                        if (hours < 10) {
                            hs = [NSString stringWithFormat:@"0%d", hours];
                        } else {
                            hs = [NSString stringWithFormat:@"%d", hours];
                        }
                        if (minute < 10) {
                            ms = [NSString stringWithFormat:@"0%d", minute];
                        } else {
                            ms = [NSString stringWithFormat:@"%d", minute];
                        }
                        if (second < 10) {
                            ss = [NSString stringWithFormat:@"0%d", second];
                        } else {
                            ss = [NSString stringWithFormat:@"%d", second];
                        }
                    } else if (!ds) {
                        if (days > 0) {
                            ds = [NSString stringWithFormat:@"%d天", days];
                        } else {
                            ds = @"";
                        }
                        if (days > 0) {
                            ds = [NSString stringWithFormat:@"%d天", days];
                        } else {
                            ds = @"";
                        }
                        if (hours < 10) {
                            hs = [NSString stringWithFormat:@"0%d", hours];
                        } else {
                            hs = [NSString stringWithFormat:@"%d", hours];
                        }
                        if (minute < 10) {
                            ms = [NSString stringWithFormat:@"0%d", minute];
                        } else {
                            ms = [NSString stringWithFormat:@"%d", minute];
                        }
                        if (second < 10) {
                            ss = [NSString stringWithFormat:@"0%d", second];
                        } else {
                            ss = [NSString stringWithFormat:@"%d", second];
                        }
                    }
                    times = [NSString stringWithFormat:@"%@%@:%@:%@.%d", ds, hs, ms, ss, count];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        wself.endTimeLab.text = [NSString stringWithFormat:@"还差%@人，结束时间%@", wself.model.needMemberNum, times];
                    });
                }
            });
            dispatch_resume(_timer);
        }
    }
}
@end
