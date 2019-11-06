//
//  SliderView.m
//  SliderView
//
//  Created by Scott on 2018/4/11.
//  Copyright © 2018年 無解. All rights reserved.
//

#define kSCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define kSCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

#import "SliderView.h"
#import "TrackView.h"

@interface SliderView ()

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *normalTrack;
@property (nonatomic, strong) TrackView *highLightTrack;
@property (nonatomic, strong) UIView *slider;

@end

@implementation SliderView

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupViewUI];
}

- (void)setupViewUI{
    [self addSubview:self.valueLabel];
    
    [self addSubview:self.highLightTrack];
    [self addSubview:self.normalTrack];
    
    [self addSubview:self.slider];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderChangeValue:)];
    [self.slider addGestureRecognizer:panGesture];
}


- (void)sliderChangeValue:(UIPanGestureRecognizer *)panChange{
    CGPoint point = [panChange translationInView:self];//slider相对位移
    static CGPoint center;//slider中心坐标
    
    if (panChange.state == UIGestureRecognizerStateBegan) {
        center = panChange.view.center;
    }
    
    CGFloat slider_x = center.x + point.x;
    
    if (slider_x <= (kSCREEN_WIDTH-self.trackSize.width)*0.5) {
        slider_x = (kSCREEN_WIDTH-self.trackSize.width)*0.5;
    }else if (slider_x >= (kSCREEN_WIDTH-self.trackSize.width)*0.5+self.trackSize.width){
        slider_x = (kSCREEN_WIDTH-self.trackSize.width)*0.5+self.trackSize.width;
    }
    
    panChange.view.center = CGPointMake(slider_x, center.y);

    self.normalTrack.frame = CGRectMake(slider_x, 10, self.trackSize.width-slider_x+(kSCREEN_WIDTH-self.trackSize.width)*0.5, self.trackSize.height);
    
    [self valueChangeWithFloat:slider_x];
}

//通过滑块移动获取当前选择Value
- (void)valueChangeWithFloat:(CGFloat)num {
    CGFloat value = (num - (kSCREEN_WIDTH-self.trackSize.width)*0.5)/self.trackSize.width*(self.maxValue-self.minValue);
    self.valueLabel.text = [NSString stringWithFormat:@"%.f",value];
}

- (void)reloadData:(CGFloat)value {
    self.normalTrack.frame = CGRectMake((kSCREEN_WIDTH-self.trackSize.width)*0.5+self.trackSize.width*(value/(self.maxValue-self.minValue)), 10, self.trackSize.width*(1- value/(self.maxValue-self.minValue)), self.trackSize.height);
    self.slider.center = CGPointMake(CGRectGetMinX(self.normalTrack.frame), self.highLightTrack.center.y);
    self.valueLabel.text = [NSString stringWithFormat:@"%.f",value];
}

#pragma mark -- lazy 懒加载所有的视图
- (UIView *)slider{
    if (!_slider) {
        _slider = [[UIView alloc] init];
        CGRect frame = _slider.frame;
        frame.size = self.thumbSize;
        _slider.frame = frame;
        _slider.center = CGPointMake(CGRectGetMinX(self.normalTrack.frame), self.highLightTrack.center.y);
        _slider.layer.cornerRadius = self.thumbSize.height/2;
        _slider.userInteractionEnabled = YES;
        
        if (self.thumbImage) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_slider.frame), CGRectGetHeight(_slider.frame))];
            imageView.image = self.thumbImage;
            [_slider addSubview:imageView];
        }else{
            _slider.backgroundColor = [UIColor blueColor];
        }
    }
    return _slider;
}

- (UIView *)normalTrack{
    if (!_normalTrack) {
        _normalTrack = [[UIView alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH-self.trackSize.width)*0.5+self.trackSize.width*(self.value/(self.maxValue-self.minValue)), 10, self.trackSize.width*(1- self.value/(self.maxValue-self.minValue)), self.trackSize.height)];
        _normalTrack.backgroundColor = self.normalColor;
        _normalTrack.layer.cornerRadius = self.trackSize.height/2;
    }
    return _normalTrack;
}

- (TrackView *)highLightTrack{
    if (!_highLightTrack) {
        _highLightTrack = [[TrackView alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH-self.trackSize.width)*0.5, 10, self.trackSize.width, self.trackSize.height)];
        _highLightTrack.startPoint = CGPointMake(0, 0);
        _highLightTrack.endPoint = CGPointMake(1, 0);
        _highLightTrack.colors = self.trackColors;
    }
    return _highLightTrack;
}


- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-20, kSCREEN_WIDTH, 20)];
        _valueLabel.text = [NSString stringWithFormat:@"%.f",self.value];
        _valueLabel.textColor = [UIColor blueColor];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.font = [UIFont systemFontOfSize:20.f];
    }
    return _valueLabel;
}

- (CGFloat)minValue{
    if (_minValue == 0) {
        _minValue = 0;
    }
    return _minValue;
}

- (CGFloat)maxValue{
    if (_maxValue == 0) {
        _maxValue = 1000;
    }
    return _maxValue;
}

- (CGFloat)value{
    if (_value == 0) {
        _value = 500;
    }else if (_value > _maxValue){
        return _maxValue;
    }else if (_value < _minValue){
        return _minValue;
    }
    return _value;
}

- (NSArray *)trackColors{
    if (!_trackColors || _trackColors.count < 2) {
        _trackColors = @[(__bridge id)[UIColor colorWithRed:255/255.f green:140/255.f blue:45/255.f alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.f green:90/255.f blue:70/255.f alpha:1.0].CGColor];
    }
    return _trackColors;
}

- (UIColor *)normalColor{
    if (_normalColor == nil) {
        _normalColor = [UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1.0];
    }
    return _normalColor;
}

- (CGSize)trackSize{
    if (![NSValue valueWithCGSize:_trackSize]) {
        _trackSize = CGSizeMake(kSCREEN_WIDTH-40, 10);
    }
    return _trackSize;
}

- (CGSize)thumbSize{
    if (![NSValue valueWithCGSize:_thumbSize]) {
        _thumbSize = CGSizeMake(25, 25);
    }
    return _thumbSize;
}

@end
