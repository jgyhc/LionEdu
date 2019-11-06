//
//  MJTextAlertController.m
//  MJAlertController_Example
//
//  Created by manjiwang on 2019/5/14.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import "MJTextAlertController.h"
#import "Masonry.h"

@interface MJTextAlertController ()

@property (nonatomic, copy) NSString * content;

@property (nonatomic, strong) UILabel * contentLabel;
@end

@implementation MJTextAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithTitle:(nullable NSString *)title content:(nullable NSString *)content buttons:(nullable NSArray *)buttons tapBlock:(nullable MJAlertControllerCompletionBlock)tapBlock {
    self = [super initWithTitle:title buttons:buttons tapBlock:tapBlock];
    if (self) {
        self.content = content;
    }
    return self;
}

- (void)initContentView {
    [super initContentView];
    if ([_content isKindOfClass:[NSString class]] && _content.length > 0) {
        [self addContentLabel];
        self.contentLabel.text = _content;
    }
}

- (CGFloat)horizontalEdge {
    return 50;
}

- (void)addContentLabel {
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
