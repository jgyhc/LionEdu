//
//  BLTopicDragDropView.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/11.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicDragDropView.h"
#import <Masonry.h>

@interface BLTopicDragDropView (){
    CGFloat _bottomHeight;
    CGFloat _currentHeight;
    CGFloat _current_y;
}

@property (nonatomic, strong) UIImageView *dragDropImageView;

@property (nonatomic, strong) UIScrollView *bootomScrollView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView * subView;
@end

@implementation BLTopicDragDropView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)setDelegate:(id<BLTopicDragDropViewDelegate>)delegate {
    _delegate = delegate;
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomScrollView)]) {
        _bootomScrollView = [self.delegate bottomScrollView];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentView)]) {
        _contentView = [self.delegate contentView];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(subView)]) {
        _subView = [self.delegate subView];
        [self addSubview:_subView];
        [_subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(22, 0, 0, 0));
        }];
    }
}

- (void)initSubviews {
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = [UIColor ]
//    [self addSubview:line];
//    line.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.6);
    [self addSubview:self.dragDropImageView];
//    [self.dragDropImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top);
//        make.centerX.mas_equalTo(self.mas_centerX);
//    }];
    self.dragDropImageView.bounds = CGRectMake(0, 0, 72, 22);
    self.dragDropImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0, 11);
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    [self.dragDropImageView addGestureRecognizer:pan];
    self.dragDropImageView.userInteractionEnabled = YES;
}


- (void)dragAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 用来保存初始高度
        _bottomHeight = CGRectGetMaxY(self.bootomScrollView.frame);
        _currentHeight = self.bounds.size.height;
        _current_y = self.frame.origin.y;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat contentHeight = [UIScreen mainScreen].bounds.size.height - 90;
        CGPoint point = [pan translationInView:self.contentView];
        CGFloat y = _current_y + point.y;
        
        // 底部scrollview最小高度
        if (y > contentHeight - 100.0) {
            y = contentHeight - 100.0;
        }else if (y < 100.0) {
            y = 100.0;
        }
        NSLog(@"y = %0.2f", y);
        // 根据拖动的位置，计算视图的高度
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateBottomScrollViewWithY:)]) {
            [self.delegate updateBottomScrollViewWithY:y];
        }
//        self.bootomScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, y - 50);
//        self.dragDropImageView.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, 40);
//        self.dragDropImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, y+11);
        self.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - y);
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
    }
}

- (UIImageView *)dragDropImageView {
    if (!_dragDropImageView) {
        _dragDropImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"t_tl"]];
    }
    return _dragDropImageView;
}

@end
