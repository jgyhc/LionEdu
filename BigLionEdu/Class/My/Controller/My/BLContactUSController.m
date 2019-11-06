//
//  BLContactUSController.m
//  BigLionEdu
//
//  Created by OrangesAL on 2019/10/13.
//  Copyright © 2019 LionEdu. All rights reserved.
//

//#import "BLContactUSController.h"
//
//@interface BLContactUSController ()
//
//@end
//
//@implementation BLContactUSController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end


//
//  BLTextAlertViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/25.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLContactUSController.h"
#import <YYLabel.h>
#import <Masonry.h>
#import "BLContactUSAPI.h"
#import <YYModel.h>
#import <YYText.h>
#import "NTCatergory.h"
#import <LCProgressHUD.h>

@interface BLContactUSController ()<MJAPIBaseManagerDelegate,CTAPIManagerParamSource>

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) YYLabel * contentLabel;

@property (nonatomic, strong) UIStackView * buttonView;

@property (nonatomic, strong) NSArray * buttons;//按钮总数

@property (nonatomic, strong) BLContactUSAPI * api;//按钮总数

@property (nonatomic, strong) NSArray * models;//按钮总数



@end

@implementation BLContactUSController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        make.left.mas_equalTo(self.containerView.mas_left).mas_offset(NTWidthRatio(20));
        make.right.mas_equalTo(self.containerView.mas_right).mas_offset(-NTWidthRatio(20));
        make.bottom.mas_equalTo(self.buttonView.mas_top);
    }];
    [self updateButtons];
    [self.view layoutIfNeeded];
    
    [self.api loadData];
}

- (BOOL)isModal {
    return YES;
}

- (CGFloat)horizontalEdge {
    return NTWidthRatio(56);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"联系我们";
        self.titleLabel.text = @"联系我们";
        self.buttons = @[@"知道了"];
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
//    if (self.tapBlock) {
//        NSInteger buttonIdx = sender.tag - 1000;
//        self.tapBlock(self, sender.currentTitle, buttonIdx);
//    }
    [self hide];
}


- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    return nil;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data{
    NSInteger code =[[data objectForKey:@"code"] integerValue];
    if (code !=200) {
        return;
    }
    
    NSArray *models = [NSArray yy_modelArrayWithClass:[BLContactUSModel class] json:data[@"data"]];
    _models = models;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    
    [models enumerateObjectsUsingBlock:^(BLContactUSModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *content = [NSString stringWithFormat:@"%@：%@\n",obj.title, obj.content];
        
        NSRange range = [content rangeOfString:obj.content];
        
        range = NSMakeRange(range.location + text.length, range.length);
        
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:content]];
        
        [text yy_setTextHighlightRange:range color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            NSString *aContent = [text.string substringWithRange:range];
            __block BLContactUSModel *model = nil;
            [self.models enumerateObjectsUsingBlock:^(BLContactUSModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.content isEqualToString:aContent]) {
                    model = obj;
                    *stop = YES;
                }
            }];
            
            if (model.isQq) {
                [[UIPasteboard generalPasteboard] setString:model.content];
                [LCProgressHUD show:@"复制成功"];
            }else {
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",model.content];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
            
            NSLog(@"%@", text.string);
        }];
        
    }];
    
    text.yy_lineSpacing = 12;
    _contentLabel.attributedText = text;

}

- (void)failManager:(CTAPIBaseManager *)manager {
    
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

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - NTWidthRatio(156);//设置最大宽度
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

- (BLContactUSAPI *)api {
    if (!_api) {
        _api = [BLContactUSAPI new];
        _api.mj_delegate = self;
        _api.paramSource = self;
    }
    return _api;
}



@end


@implementation BLContactUSModel

@end
