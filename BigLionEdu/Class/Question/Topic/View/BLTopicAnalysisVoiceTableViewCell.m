//
//  BLTopicAnalysisVoiceTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicAnalysisVoiceTableViewCell.h"


@interface BLTopicAnalysisVoiceTableViewCell ()<GKSliderViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *plyerButton;

@property (weak, nonatomic) IBOutlet GKSliderView *sliderView;
@end

@implementation BLTopicAnalysisVoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.sliderView.maximumTrackTintColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
    self.sliderView.bufferTrackTintColor =  [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
    self.sliderView.minimumTrackTintColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
//    self.sliderView.maximumTrackImage = [UIImage imageNamed:@""];
    self.sliderView.sliderHeight = 3;
    self.sliderView.delegate = self;
    self.sliderView.buttonTitle = @"00:00/00:00";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderProgressChange:) name:@"BLTopicVoiceProgressNotificationKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderdidEnd:) name:@"BLTopicVoiceDidEndNotificationKey" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)sliderdidEnd:(NSNotification *)notification {
    id obj = notification.object;
    if ([obj isEqual:self.model]) {
        self.plyerButton.selected = NO;
    }
}

- (void)sliderProgressChange:(NSNotification *)notification {
    id obj = notification.object;
    if ([obj isEqual:self.model]) {
        NSDictionary *userInfo = notification.userInfo;
        NSNumber * total = [userInfo objectForKey:@"total"];
        NSNumber * value = [userInfo objectForKey:@"value"];
        self.sliderView.buttonTitle = [NSString stringWithFormat:@"%@/%@", [self getMMSSFromSS:[value stringValue]], [self getMMSSFromSS:[total stringValue]]];
    }
}

- (NSString *)getMMSSFromSS:(NSString *)totalTime {
    long seconds = [totalTime integerValue];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02zd",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02zd",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

- (void)setModel:(BLTopicVoiceModel *)model {
    _model = model;
}

// 滑块滑动开始
- (void)sliderTouchBegan:(float)value {
    
}

// 滑块滑动中
- (void)sliderValueChanged:(float)value {
    
}

// 滑块滑动结束
- (void)sliderTouchEnded:(float)value {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderProgress:model:sliderView:)]) {
        [self.delegate sliderProgress:value model:_model sliderView:self.sliderView];
    }
}

// 滑杆点击
- (void)sliderTapped:(float)value {
    
}

- (IBAction)playerEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayer:sliderView:)]) {
            [self.delegate startPlayer:self.model sliderView:self.sliderView];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pausePlayer:sliderView:)]) {
            [self.delegate pausePlayer:_model sliderView:self.sliderView];
        }
    }
    
    
}


@end
