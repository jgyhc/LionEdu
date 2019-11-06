//
//  MJAlertController.m
//  MJAlertController_Example
//
//  Created by manjiwang on 2019/5/14.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import "MJAlertController.h"
#import "Masonry.h"

NSString * const MJAlertControllerButtonTitleKey = @"title";
NSString * const MJAlertControllerButtonTextColorKey = @"textColor";
NSString * const MJAlertControllerButtonFontKey = @"font";
NSString * const MJAlertControllerButtonNormalBackgroundColorKey = @"normalBackgroundColor";
NSString * const MJAlertControllerButtonHighlightedBackgroundColorKey = @"highlightedBackgroundColor";
@interface MJAlertController ()

@property (nonatomic, assign) CGFloat buttonsHeight;//按钮高度

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) NSArray * buttonViews;

@property (nonatomic, strong) NSArray * buttons;//按钮总数

@end

@implementation MJAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}

- (instancetype)initWithTitle:(nullable NSString *)title buttons:(nullable NSArray *)buttons tapBlock:(nullable MJAlertControllerCompletionBlock)tapBlock {
    self = [super init];
    if (self) {
        self.title = title;
        self.buttons = buttons;
        self.tapBlock = tapBlock;
    }
    return self;
}

- (void)show {
    [self addTitleView];
    [self updateButtons];
    [self initContentView];
    self.containerView.alpha = 0;
    self.containerView.transform = CGAffineTransformScale(self.containerView.transform, 0.5, 0.5);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionNone animations:^{
        self.containerView.transform = CGAffineTransformScale(self.containerView.transform, 1/0.5, 1/0.5);
        self.containerView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)initContentView {
    [self.containerView addSubview:self.contentView];
    if ([self.title isKindOfClass:[NSString class]] && self.title.length > 0) {
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(self.contentEdgeInsets.top);
            make.left.mas_equalTo(self.containerView.mas_left).mas_offset(self.contentEdgeInsets.left);
            make.right.mas_equalTo(self.containerView.mas_right).mas_offset(-self.contentEdgeInsets.right);
            make.bottom.mas_equalTo(self.containerView.mas_bottom).mas_offset(-self.buttonsHeight - self.contentEdgeInsets.bottom);
            make.height.mas_greaterThanOrEqualTo(60);
        }];
    }else {
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.containerView.mas_top).mas_offset(self.contentEdgeInsets.top);
            make.left.mas_equalTo(self.containerView.mas_left).mas_offset(self.contentEdgeInsets.left);
            make.right.mas_equalTo(self.containerView.mas_right).mas_offset(-self.contentEdgeInsets.right);
            make.bottom.mas_equalTo(self.containerView.mas_bottom).mas_offset(-self.buttonsHeight - self.contentEdgeInsets.bottom);
            make.height.mas_greaterThanOrEqualTo(60);
        }];
    }
}

- (void)updateButtons {
    CGFloat buttonHeight = [self buttonHeight];
    if (_buttons.count == 0) {
        _buttonsHeight = 0;
        return;
    }
    if (_buttons.count == 1) {
        UIButton *button = [self getButtonWithObj:[_buttons objectAtIndex:0]];
        [self.containerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.containerView.mas_bottom);
            make.left.mas_equalTo(self.containerView.mas_left);
            make.right.mas_equalTo(self.containerView.mas_right);
            make.height.mas_equalTo(buttonHeight);
//            make.top.mas_greaterThanOrEqualTo(self.containerView.mas_top).mas_offset(self.titleHeight);
        }];
        _buttonsHeight = buttonHeight;
        _buttonViews = @[button];
    }else if (_buttons.count == 2) {
        UIButton *button = [self getButtonWithObj:[_buttons objectAtIndex:0]];
        UIButton *button1 = [self getButtonWithObj:[_buttons objectAtIndex:1]];
        if (button.currentTitle.length > 6 || button1.currentTitle.length > 6) {
            [self multipleColumnsTypographyWithButtonHeight:buttonHeight];
            return;
        }
        [self.containerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.containerView.mas_left);
            make.bottom.mas_equalTo(self.containerView.mas_bottom);
            make.height.mas_equalTo(buttonHeight);
            make.width.mas_equalTo(self.containerView.mas_width).multipliedBy(0.5);
//            make.top.mas_greaterThanOrEqualTo(self.containerView.mas_top).mas_offset(self.titleHeight);
        }];
        
        [self.containerView addSubview:button1];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.containerView.mas_bottom);
            make.right.mas_equalTo(self.containerView.mas_right).mas_offset(-0.5);
            make.height.mas_equalTo(buttonHeight);
            make.width.mas_equalTo(self.containerView.mas_width).multipliedBy(0.5).mas_offset(1);
//            make.top.mas_greaterThanOrEqualTo(self.containerView.mas_top).mas_offset(self.titleHeight);
        }];
        _buttonsHeight = buttonHeight;
        _buttonViews = @[button, button1];
    }else {
        [self multipleColumnsTypographyWithButtonHeight:buttonHeight];
    }
}

- (void)addTitleView {
    if ([self.title isKindOfClass:[NSString class]] && self.title.length > 0) {
        self.titleLabel.text = self.title;
        [self.containerView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.containerView.mas_left);
            make.right.mas_equalTo(self.containerView.mas_right);
            make.top.mas_equalTo(self.containerView.mas_top).mas_offset(20);
        }];
    }
}

- (CGFloat)buttonHeight {
    return 44.0;
}

- (UIEdgeInsets)contentEdgeInsets {
    return UIEdgeInsetsMake(20, 15, 15, 15);
}


- (void)multipleColumnsTypographyWithButtonHeight:(CGFloat)buttonHeight {
    CGFloat bottomSpace = 0;
    NSMutableArray *buttons = [NSMutableArray array];
    for (NSInteger idx = _buttons.count - 1; idx >= 0; idx --) {
        UIButton *button = [self getButtonWithObj:_buttons[idx]];
        [buttons addObject:button];
        [self.containerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.containerView.mas_left);
            make.right.mas_equalTo(self.containerView.mas_right);
            make.height.mas_equalTo(buttonHeight);
            make.bottom.mas_equalTo(self.containerView.mas_bottom).mas_offset(-1 * bottomSpace);
//            make.top.mas_greaterThanOrEqualTo(self.containerView.mas_top).mas_offset(self.titleHeight);
        }];
        bottomSpace = bottomSpace + buttonHeight - 0.5;
    }
    _buttonViews = buttons;
    _buttonsHeight = bottomSpace;
}


- (void)handleButtonEvent:(UIButton *)sender {
    if (self.tapBlock) {
        __block NSInteger buttonIdx = 0;
        [_buttonViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:sender]) {
                buttonIdx = idx;
            }
        }];
        self.tapBlock(self, sender.currentTitle, buttonIdx);
    }
    [self hide];
}

- (UIButton *)getButtonWithObj:(id)obj {
    if ([obj isKindOfClass:[UIButton class]]) {
        return obj;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0].CGColor;
    button.layer.borderWidth = 0.5;
    NSString *title;
    UIColor *textColor = [UIColor colorWithRed:55/255.0 green:161/255.0 blue:255/255.0 alpha:1.0];
    UIColor *backgroundColor = [UIColor whiteColor];
    UIColor *highlightedBackgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    UIFont *titleFont = [UIFont systemFontOfSize:15];
    if ([obj isKindOfClass:[NSString class]]) {
        title = obj;
    }else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = obj;
        title = [dictionary objectForKey:MJAlertControllerButtonTitleKey];
        UIColor *color = [dictionary objectForKey:MJAlertControllerButtonTextColorKey];
        if (color) {
            textColor = color;
        }
        UIFont *font = [dictionary objectForKey:MJAlertControllerButtonFontKey];
        if (font) {
            titleFont = font;
        }
        UIColor *objBackgroundColor = [dictionary objectForKey:MJAlertControllerButtonNormalBackgroundColorKey];
        if (objBackgroundColor) {
            backgroundColor = objBackgroundColor;
        }
        UIColor *objHighlightedBackgroundColor = [dictionary objectForKey:MJAlertControllerButtonHighlightedBackgroundColorKey];
        if (objHighlightedBackgroundColor) {
            highlightedBackgroundColor = objHighlightedBackgroundColor;
        }
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = titleFont;
    [button setBackgroundImage:[self imageWithColor:backgroundColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:highlightedBackgroundColor] forState:UIControlStateHighlighted];
    return button;
}


- (CGFloat)horizontalEdge {
    return 35;
}

- (BOOL)isModal {
    return YES;
}

- (CGFloat)containerCircular {
    return 12.0;
}

#pragma mark -- getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    return _titleLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
