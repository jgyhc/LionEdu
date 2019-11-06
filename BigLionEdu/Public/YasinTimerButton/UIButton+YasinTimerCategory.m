//
//  UIButton+YasinTimerCategory.m
//  GreenYears
//
//  Created by Yasin on 2017/11/3.
//  Copyright © 2017年 Yasin. All rights reserved.
//

//注意：如果按钮出现闪烁，将xib或者storyboard中Type属性设置为custom即可

#import "UIButton+YasinTimerCategory.h"
//#import "UIColor+NTAdd.h"

static NSString *yasinTempText;

@implementation UIButton (YasinTimerCategory)

- (void)startCountDownTime:(int)time withCountDownBlock:(void(^)(void))countDownBlock{
    
    [self initButtonData];
    
    [self startTime:time];
    
    if (countDownBlock) {
        countDownBlock();
    }
}

- (void)initButtonData{
    
    yasinTempText = [NSString stringWithFormat:@"%@",self.titleLabel.text];
  
}

- (void)startTime:(int)time {
    __block int timeout = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    __weak __typeof(self)wself = self;
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束
        if(timeout <= 0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.layer.borderColor = [self colorWithRGB:0xFF7349 alpha:1].CGColor;
                [wself setTitleColor:[self colorWithRGB:0xFF7349 alpha:1] forState:UIControlStateNormal];
                [wself setTitle:@"获取验证码" forState:UIControlStateNormal];
                wself.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *text = [NSString stringWithFormat:@"%02ds",timeout];
                [wself setTitle:text forState:UIControlStateNormal];
                [wself setTitleColor:[self colorWithRGB:0x666666 alpha:1] forState:UIControlStateNormal];
                wself.layer.borderColor = [self colorWithRGB:0x666666 alpha:1].CGColor;
                wself.userInteractionEnabled = NO;
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
}

- (UIColor*)colorWithRGB:(NSUInteger)hex alpha:(CGFloat)alpha{
    float r, g, b, a;
    a = alpha;
    b = hex & 0x0000FF;
    hex = hex >> 8;
    g = hex & 0x0000FF;
    hex = hex >> 8;
    r = hex;
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

//UIColor 转UIImage（UIImage+YYAdd.m也是这种实现）
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
