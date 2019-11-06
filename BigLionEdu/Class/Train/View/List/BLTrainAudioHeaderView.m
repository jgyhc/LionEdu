//
//  BLTrainShareInfoCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainAudioHeaderView.h"
#import "BLVoiceSpeedAlertView.h"
#import <SDWebImage.h>
#import <AVFoundation/AVFoundation.h>
#import "NTCatergory.h"
#import <Masonry.h>

@interface BLTrainAudioHeaderView ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *item;
@property (nonatomic, strong) id observer;
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, strong) UIButton *tip;

@end

@implementation BLTrainAudioHeaderView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.item removeObserver:self forKeyPath:@"status" context:nil];
    [self.item removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [self.player removeTimeObserver:self.observer];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self rt_initailizeUI];
    }
    return self;
}

- (void)rt_initailizeUI {
    self.photo = [UIImageView new];
    self.photo.cornerRadius = 5;
    [self addSubview:self.photo];
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(120, 132));
    }];
    
    self.sxk = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sxk.titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    self.sxk.titleLabel.numberOfLines = 0;
    [self.sxk setTitle:@"狮享刻" forState:UIControlStateNormal];
    [self.sxk setBackgroundImage:[UIImage imageNamed:@"sx_sxk"] forState:UIControlStateNormal];
    self.sxk.titleLabel.font = [UIFont systemFontOfSize:9];
    [self.sxk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.sxk];
    [self.sxk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.photo.mas_right);
        make.top.equalTo(self.photo.mas_top);
        make.size.mas_equalTo(CGSizeMake(13, 37));
    }];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"sx_bf"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"t_stop"] forState:UIControlStateSelected];
    [self addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(-25);
    }];
    
    self.prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.prevBtn setBackgroundImage:[UIImage imageNamed:@"sx_kt"] forState:UIControlStateNormal];
    self.prevBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.prevBtn setTitle:@"15" forState:UIControlStateNormal];
    [self.prevBtn setTitleColor:[UIColor nt_colorWithHexString:@"#878C97"] forState:UIControlStateNormal];
    [self addSubview:self.prevBtn];
    [self.prevBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).offset(19);
        make.centerY.equalTo(self.playBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.speed = [UIButton buttonWithType:UIButtonTypeCustom];
    self.speed.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.speed setTitleColor:[UIColor nt_colorWithHexString:@"#878C97"] forState:UIControlStateNormal];
    [self.speed setTitle:@"倍速" forState:UIControlStateNormal];
    [self addSubview:self.speed];
    [self.speed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.playBtn.mas_centerY);
    }];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"sx_kj"] forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.nextBtn setTitle:@"15" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor nt_colorWithHexString:@"#878C97"] forState:UIControlStateNormal];
    [self addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.speed.mas_left).offset(-20);
        make.centerY.equalTo(self.playBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.process = [[UISlider alloc] init];
    [self addSubview:self.process];
    [self.process mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.prevBtn.mas_right).offset(10);
        make.right.equalTo(self.nextBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.playBtn.mas_centerY);
    }];
    
    self.tip = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.tip setBackgroundColor:[UIColor nt_colorWithHexString:@"#404040" alpha:1]];
    self.tip.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.tip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tip setTitle:@"00:00/00:00" forState:UIControlStateNormal];
    [self addSubview:self.tip];
    self.tip.frame = CGRectMake(self.process.nt_x + 6.0, self.process.nt_centerY - 9.0, 64, 18);
    self.tip.cornerRadius = 9.0;
    [self.tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.process.mas_left).offset(6);
        make.centerY.equalTo(self.process.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(64, 18));
    }];
    
    [self.playBtn addTarget:self action:@selector(bl_playAction:) forControlEvents:UIControlEventTouchUpInside];
    _current = 1;
    [self.speed addTarget:self action:@selector(bl_showVoiceSpeed) forControlEvents:UIControlEventTouchUpInside];
    [self.process setThumbImage:[UIImage imageNamed:@"p_th"] forState:UIControlStateNormal];
    [self.process setTintColor:[UIColor nt_colorWithHexString:@"#FF6B00"]];
    [self.process addTarget:self action:@selector(playSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.process addTarget:self action:@selector(showTime) forControlEvents:UIControlEventTouchUpInside];
    
    [self.process setValue:0 animated:NO];
    [self.prevBtn addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
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

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
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
            if (process > 0.02) {
                [wself.process setValue:process animated:YES];
            }
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
        } else {
            NSLog(@"准备播放");
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
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
            self.playBtn.selected = YES;
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
            self.playBtn.selected = YES;
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
