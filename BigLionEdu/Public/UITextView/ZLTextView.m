//
//  ZLTextView.m
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "ZLTextView.h"
#import <Masonry.h>

@interface ZLTextView ()

@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation ZLTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSubViews];
}

- (void)initSubViews {
    [self addSubview:self.textView];
    [self addSubview:self.numberLabel];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 35));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-12);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-12);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textView.text = text;
    NSInteger fontNum = text.length;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld", fontNum, _maxWords];
}

- (void)textViewEditChanged:(NSNotification*)obj {
    UITextView *textView = self.textView;
    NSString *textStr = textView.text;
    NSInteger fontNum = textStr.length;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld", fontNum, _maxWords];
    if (textStr.length > _maxWords) {
        textView.text = [textStr substringToIndex:_maxWords];
    }
    _text = textView.text;
}


- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textView.placeholder = placeholder;
}

- (void)setMaxWords:(NSInteger)maxWords {
    _maxWords = maxWords;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.textView.text.length, maxWords];
}

#pragma mark -  getter
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
            label;
        });
    }
    return _numberLabel;
}

- (IQTextView *)textView {
    if (!_textView) {
        _textView = [[IQTextView alloc] init];
        _textView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:247/255.0 alpha:1.0];
        _textView.font = [UIFont systemFontOfSize:14];
    }
    return _textView;
}
@end
