//
//  BLTrainShareInfoCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainShareInfoCell.h"
#import "BLVoiceSpeedAlertView.h"
#import <SDWebImage.h>
#import <AVFoundation/AVFoundation.h>
#import "NTCatergory.h"

@interface BLTrainShareInfoCell ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *item;
@property (nonatomic, strong) id observer;
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, strong) UIButton *tip;

@end

@implementation BLTrainShareInfoCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.item removeObserver:self forKeyPath:@"status" context:nil];
    [self.item removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [self.player removeTimeObserver:self.observer];
}


- (void)bl_playAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.playBtn addTarget:self action:@selector(bl_playAction:) forControlEvents:UIControlEventTouchUpInside];
    _current = 1;
    [self.speed addTarget:self action:@selector(bl_showVoiceSpeed) forControlEvents:UIControlEventTouchUpInside];
    [self.process setThumbImage:[UIImage imageNamed:@"p_th"] forState:UIControlStateNormal];
    [self.process addTarget:self action:@selector(playSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.process addTarget:self action:@selector(showTime) forControlEvents:UIControlEventTouchUpInside];
    
    self.process.value = 0.0;
    [self.prevBtn addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tip = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.tip setBackgroundColor:[UIColor nt_colorWithHexString:@"#404040" alpha:1]];
    self.tip.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.tip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tip setTitle:@"00:00/00:00" forState:UIControlStateNormal];
    [self.contentView addSubview:self.tip];
    self.tip.frame = CGRectMake(self.process.nt_x + 6.0, self.process.nt_centerY - 9.0, 64, 18);
    self.tip.cornerRadius = 9.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bl_showVoiceSpeed {
    BLVoiceSpeedAlertView *view = [BLVoiceSpeedAlertView new];
    view.current = self.current;
    __weak typeof(self) wself = self;
    [view setDidSelectHandler:^(NSInteger index) {
        wself.current = index;
        if (wself.current == 0) {
            wself.player.rate = 0.75;
        } else if (wself.current == 1) {
            wself.player.rate = 1.0;
        } else if (wself.current == 2) {
            wself.player.rate = 1.25;
        } else if (wself.current == 3) {
            wself.player.rate = 1.5;
        } else if (wself.current == 4) {
            wself.player.rate = 2.0;
        }
    }];
    [view show];
}

- (void)setModel:(BLTrainCurriculumDetailModel *)model {
    if (!_model) {
        _model = model;
        [self.photo sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:model.coverImg?:@""]] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
        NSURL * url  = [NSURL URLWithString:[IMG_URL stringByAppendingString:model.lionFilePath]?:@""];
        AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
        self.item = songItem;
        self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
        [self playTimeObserver];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];

    }
}

- (void)playTimeObserver {
    __weak typeof(self) wself = self;
    self.observer = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        CGFloat totalTime = CMTimeGetSeconds(wself.item.duration);
        if (currentTime) {
            CGFloat process = currentTime / totalTime;
            [wself.process setValue:process animated:YES];
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //判断链接状态
    if ([keyPath isEqualToString:@"status"]) {
        if (self.item.status == AVPlayerItemStatusFailed) {
            NSLog(@"连接失败");
        }else if (self.item.status == AVPlayerItemStatusUnknown){
            NSLog(@"未知的错误");
        }else{
            NSLog(@"准备播放");
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            [self.player play];
            [self.tip setTitle:[NSString stringWithFormat:@"%@/%@", [self timeStringWithSecond:0], [self timeStringWithSecond:CMTimeGetSeconds(self.player.currentItem.duration)]] forState:UIControlStateNormal];
            [UIView animateWithDuration:4.0 animations:^{
                self.tip.alpha = 0;
            }];
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *timeRanges = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
        [self updateLoadedTimeRanges:timeRanges];
    }
}

- (void)showTime {
    self.tip.alpha = 1;
}

- (void)playSliderValueChange:(UISlider *)sender {
    [self.player pause];
    float seconds = sender.value * CMTimeGetSeconds(self.player.currentItem.duration);
    self.tip.nt_x = sender.value * sender.nt_width + sender.nt_x + 6.0;
    //让视频从指定的CMTime对象处播放。
    NSLog(@"快进  %lf", seconds);
    [self.tip setTitle:[NSString stringWithFormat:@"%@/%@", [self timeStringWithSecond:seconds], [self timeStringWithSecond:CMTimeGetSeconds(self.player.currentItem.duration)]] forState:UIControlStateNormal];
    CMTime startTime = CMTimeMakeWithSeconds(seconds, self.item.currentTime.timescale);
    //让视频从指定处播放
    [self.player seekToTime:startTime completionHandler:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:4.0 animations:^{
                self.tip.alpha = 0;
            }];
        }
    }];
}

- (NSString *)timeStringWithSecond:(NSInteger)seconds {
    NSInteger m = seconds / 60;
    NSInteger s = seconds - (m * 60);
    NSString *ms = @"";
    NSString *ss = @"";
    if (m <= 9) {
        ms = [NSString stringWithFormat:@"0%ld", m];
    } else {
        ms = [NSString stringWithFormat:@"%ld", m];
    }
    if (s <= 9) {
        ss = [NSString stringWithFormat:@"0%ld", s];
    } else {
        ss = [NSString stringWithFormat:@"%ld", s];
    }
    return [NSString stringWithFormat:@"%@:%@", ms, ss];
}

- (void)add {
    [self.player pause];
    float seconds = CMTimeGetSeconds(self.player.currentItem.currentTime) + 15;
    //让视频从指定的CMTime对象处播放。
    NSLog(@"快进  %lf", seconds);
    CMTime startTime = CMTimeMakeWithSeconds(seconds, self.item.currentTime.timescale);
    //让视频从指定处播放
    [self.player seekToTime:startTime completionHandler:^(BOOL finished) {
        if (finished) {
            [self.player play];
        }
    }];
}

- (void)reduce {
    [self.player pause];
    float seconds = CMTimeGetSeconds(self.player.currentItem.currentTime) - 15;
    //让视频从指定的CMTime对象处播放。
    NSLog(@"快进  %lf", seconds);
    CMTime startTime = CMTimeMakeWithSeconds(seconds, self.item.currentTime.timescale);
    //让视频从指定处播放
    [self.player seekToTime:startTime completionHandler:^(BOOL finished) {
        if (finished) {
            [self.player play];
        }
    }];
}

- (void)playEnd {
    
}


- (void)updateLoadedTimeRanges:(NSArray *)timeRanges {
    if (timeRanges && [timeRanges count]) {
        CMTimeRange timerange = [[timeRanges firstObject] CMTimeRangeValue];
        CMTime bufferDuration = CMTimeAdd(timerange.start, timerange.duration);
        // 获取到缓冲的时间,然后除以总时间,得到缓冲的进度
        NSLog(@"%f",CMTimeGetSeconds(bufferDuration));
    }
}


@end
