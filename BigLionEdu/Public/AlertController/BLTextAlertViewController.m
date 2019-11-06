//
//  BLTextAlertViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/25.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTextAlertViewController.h"
#import <Masonry.h>

NSString * const BLAlertControllerButtonTitleKey = @"title";
NSString * const BLAlertControllerButtonTextColorKey = @"textColor";
NSString * const BLAlertControllerButtonFontKey = @"font";
NSString * const BLAlertControllerButtonNormalBackgroundColorKey = @"normalBackgroundColor";
NSString * const BLAlertControllerButtonHighlightedBackgroundColorKey = @"highlightedBackgroundColor";
NSString * const BLAlertControllerButtonRoundedCornersKey = @"roundedCorners";
NSString * const BLAlertControllerButtonBorderWidthKey = @"borderWidth";
NSString * const BLAlertControllerButtonBorderColorKey = @"borderColor";
@interface BLTextAlertViewController ()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * contentLabel;

@property (nonatomic, strong) UIStackView * buttonView;

@property (nonatomic, strong) NSArray * buttons;//按钮总数

@property (nonatomic, strong) UIView *mask;

@end

@implementation BLTextAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mask = [UIView new];
    [self.view insertSubview:self.mask belowSubview:self.containerView];
    [self.mask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.mask.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bl_tap)];
    [self.mask addGestureRecognizer:tap];
    
    
    [self.containerView setBackgroundColor:[UIColor whiteColor]];
    self.containerView.clipsToBounds = YES;
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.containerView);
        make.height.mas_equalTo(53);
    }];
    
    [self.containerView addSubview:self.buttonView];
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView.mas_centerX);
        make.height.mas_equalTo(72);
        make.bottom.mas_equalTo(self.containerView.mas_bottom);
    }];
    
    [self.containerView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.containerView.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.containerView.mas_right).mas_offset(-20);
        make.bottom.mas_equalTo(self.buttonView.mas_top);
    }];
    [self updateButtons];
    [self.view layoutIfNeeded];
}

- (void)bl_tap {
    [self hide];
}

- (BOOL)isModal {
    return YES;
}

- (CGFloat)horizontalEdge {
    return 56;
}

- (instancetype)initWithTitle:(nullable NSString *)title content:(NSString *)content buttons:(nullable NSArray *)buttons tapBlock:(nullable BLAlertControllerCompletionBlock)tapBlock {
    self = [super init];
    if (self) {
        self.title = title;
        self.titleLabel.text = title;
        self.contentLabel.text = content;
        self.buttons = buttons;
        self.tapBlock = tapBlock;
    }
    return self;
}


//- (void)show {
//
//    self.containerView.alpha = 0;
//    self.containerView.transform = CGAffineTransformScale(self.containerView.transform, 0.5, 0.5);
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionNone animations:^{
//        self.containerView.transform = CGAffineTransformScale(self.containerView.transform, 1/0.5, 1/0.5);
//        self.containerView.alpha = 1;
//    } completion:^(BOOL finished) {
//    }];
//}


- (void)updateButtons {
    NSMutableArray *buttons = [NSMutableArray array];
    for (NSInteger idx = _buttons.count - 1; idx >= 0; idx --) {
        UIButton *button = [self getButtonWithObj:_buttons[idx] tag:idx + 1000];
        [buttons addObject:button];
        [self.buttonView addArrangedSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(82);
            make.height.mas_equalTo(29);
        }];
    }
}


- (UIButton *)getButtonWithObj:(id)obj tag:(NSInteger)tag {
    if ([obj isKindOfClass:[UIButton class]]) {
        return obj;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIColor * borderColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    CGFloat borderWidth = 0.5;
    NSString *title;
    UIColor *textColor = [UIColor whiteColor];
    UIColor *backgroundColor =  [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    UIColor *highlightedBackgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    UIFont *titleFont = [UIFont systemFontOfSize:13];
    CGFloat cornerRadius = 5;
    if ([obj isKindOfClass:[NSString class]]) {
        title = obj;
    }else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = obj;
        UIColor *objBorderColor = [dictionary objectForKey:BLAlertControllerButtonBorderColorKey];
        if (objBorderColor) {
            borderColor = objBorderColor;
        }
        
        CGFloat objBorderWidth = [[dictionary objectForKey:BLAlertControllerButtonBorderWidthKey] floatValue];
        if (objBorderWidth) {
            borderWidth = objBorderWidth;
        }
        
        CGFloat objCornerRadius = [[dictionary objectForKey:BLAlertControllerButtonRoundedCornersKey] floatValue];
        if (objCornerRadius) {
            cornerRadius = objCornerRadius;
        }
        
        title = [dictionary objectForKey:BLAlertControllerButtonTitleKey];
        UIColor *color = [dictionary objectForKey:BLAlertControllerButtonTextColorKey];
        if (color) {
            textColor = color;
        }
        UIFont *font = [dictionary objectForKey:BLAlertControllerButtonFontKey];
        if (font) {
            titleFont = font;
        }
        UIColor *objBackgroundColor = [dictionary objectForKey:BLAlertControllerButtonNormalBackgroundColorKey];
        if (objBackgroundColor) {
            backgroundColor = objBackgroundColor;
        }
        UIColor *objHighlightedBackgroundColor = [dictionary objectForKey:BLAlertControllerButtonHighlightedBackgroundColorKey];
        if (objHighlightedBackgroundColor) {
            highlightedBackgroundColor = objHighlightedBackgroundColor;
        }
    }
    button.layer.borderColor = borderColor.CGColor;
    button.layer.borderWidth = borderWidth;
    button.layer.cornerRadius = cornerRadius;
    button.clipsToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = titleFont;
    [button setBackgroundImage:[self imageWithColor:backgroundColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:highlightedBackgroundColor] forState:UIControlStateHighlighted];
    return button;
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

- (void)handleButtonEvent:(UIButton *)sender {
    if (self.tapBlock) {
        NSInteger buttonIdx = sender.tag - 1000;
        self.tapBlock(self, sender.currentTitle, buttonIdx);
    }
    [self hide];
}



- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.clipsToBounds = YES;
        _titleLabel.backgroundColor = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:250/255.0 alpha:1.0];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}


- (UIStackView *)buttonView {
    if (!_buttonView) {
        _buttonView = [UIStackView new];
        _buttonView.axis = UILayoutConstraintAxisHorizontal;
        _buttonView.alignment = UIStackViewAlignmentCenter;
        _buttonView.distribution = UIStackViewDistributionEqualSpacing;
        _buttonView.spacing = 40;
    }
    return _buttonView;
}
@end
