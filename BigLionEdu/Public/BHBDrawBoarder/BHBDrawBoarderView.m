//
//  BHBDrawBoarderView.m
//  BHBDrawBoarder
//
//  Created by bihongbo on 16/1/4.
//  Copyright © 2016年 bihongbo. All rights reserved.
//
// 屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#import "BHBDrawBoarderView.h"
#import "BHBScrollView.h"
#import "BHBMyDrawer.h"
#import <Masonry.h>
#import "AdaptScreenHelp.h"

@interface BHBDrawBoarderView ()
{
    
    /** 工具条的view */
    UIView *_toolView;

    /** 画板view */
    BHBScrollView *_boardView;
    
}


/** 按钮图片 */
@property (nonatomic, strong) NSArray   * buttonImgNames;
/** 按钮不可用图片 */
@property (nonatomic, strong) NSArray   * btnEnableImgNames;

@property (nonatomic, strong)BHBMyDrawer * myDrawer;

@property (nonatomic, strong)UIButton * delAllBtn;//删除
@property (nonatomic, strong)UIButton * fwBtn;//上一步
@property (nonatomic, strong)UIButton * ntBtn;//下一步


@end


@implementation BHBDrawBoarderView

- (BHBMyDrawer *)myDrawer
{
    if (_myDrawer == nil) {
        _myDrawer = [[BHBMyDrawer alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width*5, SCREEN_SIZE.height*2)];
        _myDrawer.layer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _myDrawer;
    
}


- (NSArray *)btnEnableImgNames
{
    if (_btnEnableImgNames == nil) {
        _btnEnableImgNames = @[@"close_draft_enable",@"delete_draft_enable",@"undo_draft_enable",@"redo_draft_enable"];
    }
    return _btnEnableImgNames;
}


- (NSArray *)buttonImgNames
{
    if (_buttonImgNames == nil) {
        _buttonImgNames = @[@"close_draft",@"delete_draft",@"undo_draft",@"redo_draft"];
    }
    return _buttonImgNames;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height);
    self = [super initWithFrame:frame];
    if (self) {
        
        //顶部工具条
        UIView * toolV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 44 + StatusBarHeight())];
        toolV.backgroundColor = [UIColor whiteColor];
        [self addSubview:toolV];
        _toolView = toolV;
        
//        //顶部按钮
//        CGFloat btnW = toolV.bounds.size.width/4.0f;
//        CGFloat btnH =toolV.bounds.size.height-20;
//
//        for (int i = 0; i<4; i++) {
//            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.frame = CGRectMake(i*btnW, StatusBarHeight(), btnW, btnH);
//
//            UIImage * img = [UIImage imageNamed:self.buttonImgNames[i]];
//            UIImage * imgDis = [UIImage imageNamed:self.btnEnableImgNames[i]];
//            [btn setImage:img forState:UIControlStateNormal];
//            [btn setImage:img forState:UIControlStateSelected];
//            [btn setImage:imgDis forState:UIControlStateDisabled];
//            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
//            btn.tag = i+100;
//            [_toolView addSubview:btn];
//            if (i > 0) [btn setEnabled:NO];
//        }
        
        
//        self.delAllBtn = (UIButton *)[_toolView viewWithTag:101];
//        self.fwBtn = (UIButton *)[_toolView viewWithTag:102];
//        self.ntBtn = (UIButton *)[_toolView viewWithTag:103];
        
        UIView *view = [UIView new];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerEvent)]];
        [_toolView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_toolView.mas_right).mas_offset(-10);
            make.bottom.mas_equalTo(_toolView.mas_bottom);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(60);
        }];
        UIImageView *imageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setImage:[UIImage imageNamed:@"t_ql"]];
            imageView;
        });
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view);
            make.top.mas_equalTo(view.mas_top);
        }];
        UILabel *label = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.text = @"清空笔记";
            label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            label;
        });
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view);
            make.bottom.mas_equalTo(view.mas_bottom).mas_offset(-6);
        }];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"nav_black_back_icon"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(handlerBackEvent) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_toolView);
            make.left.mas_equalTo(_toolView);
            make.width.height.mas_equalTo(44);
        }];
        
        
        [self.myDrawer addObserver:self forKeyPath:@"lines" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.myDrawer addObserver:self forKeyPath:@"canceledLines" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        //画板view
        BHBScrollView * boardV = [[BHBScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(toolV.frame), SCREEN_SIZE.width, SCREEN_SIZE.height - CGRectGetMaxY(toolV.frame))];
        
        boardV.layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.15].CGColor;
        [boardV setUserInteractionEnabled:YES];
        [boardV setScrollEnabled:YES];
        [boardV setMultipleTouchEnabled:YES];
        [boardV addSubview:self.myDrawer];
        [boardV setContentSize:self.myDrawer.frame.size];
        [boardV setDelaysContentTouches:NO];
        [boardV setCanCancelContentTouches:NO];
        [self insertSubview:boardV belowSubview:_toolView];
        
        _boardView = boardV;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}


- (void)show {
    
    _myDrawer.lines = [NSMutableArray arrayWithArray:self.linesInfo];
    for (CALayer * layer in _myDrawer.lines) {
        [_myDrawer.layer addSublayer:layer];
    }
    
    [UIView animateWithDuration:.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frame = self.frame;
                         frame.origin.y -= frame.size.height ;
                         [self setFrame:frame];
                         
                     }completion:nil];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frame = self.frame;
                         frame.origin.y += frame.size.height ;
                         [self setFrame:frame];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         if (finished) {
                             if (self.draftInfoBlock) {
                                 self.draftInfoBlock(self.num, _myDrawer.lines, _myDrawer.canceledLines);
                             }
                         }
                         
                         [self removeFromSuperview];
                         
                         [self.myDrawer removeObserver:self forKeyPath:@"canceledLines"];
                         [self.myDrawer removeObserver:self forKeyPath:@"lines"];
                     }];
}


- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            [self dismiss];
            break;
        case 101:
            [_myDrawer clearScreen];
            break;
        case 102:
            [_myDrawer undo];
            break;
        case 103:
            [_myDrawer redo];
            break;
        default:
            break;
    }
}

- (void)handlerEvent {
    [_myDrawer clearScreen];
}

- (void)handlerBackEvent {
    [self dismiss];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if([keyPath isEqualToString:@"lines"]){
        NSMutableArray * lines = [_myDrawer mutableArrayValueForKey:@"lines"];
        if (lines.count) {
            [self.delAllBtn setEnabled:YES];
            [self.fwBtn setEnabled:YES];
            
        }else{
            [self.delAllBtn setEnabled:NO];
            [self.fwBtn setEnabled:NO];
        }
    }else if([keyPath isEqualToString:@"canceledLines"]){
        NSMutableArray * canceledLines = [_myDrawer mutableArrayValueForKey:@"canceledLines"];
        if (canceledLines.count) {
            [self.ntBtn setEnabled:YES];
        }else{
            [self.ntBtn setEnabled:NO];
            
        }
        
    }
}



@end
