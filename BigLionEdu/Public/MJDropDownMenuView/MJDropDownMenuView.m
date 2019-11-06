//
//  MJDropDownMenuView.m
//  ManJi
//
//  Created by manjiwang on 2018/7/28.
//  Copyright © 2018年 Zgmanhui. All rights reserved.
//

#import "MJDropDownMenuView.h"
#import "Masonry.h"

#define MJUIKit_UICOLOR_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
static CGFloat cellHeight = 41;
@interface MJDropDownMenuView ()<UITableViewDelegate, UITableViewDataSource, MJDropDownMenuFontCellDelete>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UITableView *tabelView;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) MASConstraint * heightConstraint;
@end

@implementation MJDropDownMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.backgroundColor = [UIColor clearColor];
    self.maskView.backgroundColor = [UIColor clearColor];
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self addSubview:_backgroundView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    [self addSubview:self.contentView];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-5);
        make.width.mas_equalTo(122);
        self.heightConstraint = make.height.mas_equalTo(5 + 400);
        make.top.mas_equalTo(self).mas_offset(34 + statusBarFrame.size.height);
    }];
    
    [self.contentView addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self.contentView addSubview:self.tabelView];
    [self.tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 0, 0, 0));
    }];
    
    [self.tabelView registerClass:[MJDropDownMenuCell class] forCellReuseIdentifier:NSStringFromClass([MJDropDownMenuCell class])];
    [self.tabelView registerClass:[MJDropDownMenuFontCell class] forCellReuseIdentifier:NSStringFromClass([MJDropDownMenuFontCell class])];
    
}


- (void)reloadData {
    [self.tabelView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = self.dataSource[indexPath.row];
    if ([data isKindOfClass:[MJDropDownMenuItem class]]) {
        MJDropDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MJDropDownMenuCell class])];
        cell.item = self.dataSource[indexPath.row];
        return cell;
    }
    MJDropDownMenuFontCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MJDropDownMenuFontCell class])];
    cell.idx = _idx;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownMenuView:didSelectItem:)]) {
        [self.delegate dropDownMenuView:self didSelectItem:indexPath.row];
    }
}

- (void)didSelectFontIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectFontIndex:)]) {
        [self.delegate didSelectFontIndex:index];
    }
}

#pragma mark -- show
- (void)show {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceDropDownMenuView:)]) {
        NSArray<MJDropDownMenuItem *> *dataSource = [self.delegate dataSourceDropDownMenuView:self];
        self.dataSource = dataSource;
        [self.tabelView reloadData];
        CGFloat height = 5 + dataSource.count * cellHeight;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [_heightConstraint uninstall];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        [self layoutIfNeeded];
        self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 0.5, 0.5);
        [self.contentView.layer setAnchorPoint:CGPointMake(0.8, 0)];
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        [self.contentView.layer setPosition:CGPointMake(screenWidth - 30, 37 + statusBarFrame.size.height)];
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionNone animations:^{
            self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 1/0.5, 1/0.5);
        } completion:^(BOOL finished) {
        }];
    }
}
#pragma mark -- remove
- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 0.5, 0.5);
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        self.contentView.alpha = 1;
        self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 1/0.5, 1/0.5);
        [self removeFromSuperview];
    }];
}


- (UITableView *)tabelView {
    if(_tabelView == nil) {
        _tabelView = [[UITableView alloc] init];
        _tabelView.rowHeight = cellHeight;
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabelView.delegate = self;
        _tabelView.scrollEnabled = NO;
        _tabelView.dataSource = self;
        _tabelView.backgroundColor = [UIColor clearColor];
    }
    return _tabelView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.maskView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        UIImage *image = [[UIImage imageNamed:@"xin_tankuang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _backgroundImageView.image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    }
    return _backgroundImageView;
}

@end

@implementation MJDropDownMenuItem

@end

@implementation MJDropDownMenuCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:_titleLabel];

        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(18);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(12);
        }];
        
//        [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
//            make.centerX.mas_equalTo(_iconImageView.centerX).mas_equalTo(4);
//        }];
//        self.badgeView.center = CGPointMake(23, 17);
        
        UIView *line = [UIView new];
        [line setBackgroundColor:MJUIKit_UICOLOR_HEX(0x7A7A7A)];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
            make.height.mas_equalTo(0.6);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

- (void)setItem:(MJDropDownMenuItem *)item {
    _item = item;
    self.iconImageView.image = [UIImage imageNamed:item.imageName];
    self.titleLabel.text = item.title;
}

@end

@interface MJDropDownMenuFontCell ()

@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, strong) UIButton *currentButton;
@end

@implementation MJDropDownMenuFontCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIStackView *stackView = [[UIStackView alloc] init];
        _stackView = stackView;
        [self.contentView addSubview:stackView];
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 5));
        }];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.distribution = UIStackViewDistributionFillEqually;
        UIButton *font13Button = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"Aa" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1000;
            button;
        });
        
        UIButton *font14Button = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"Aa" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1001;
            button;
        });
        
        UIButton *font16Button = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"Aa" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1002;
            button;
        });
        
        [stackView addArrangedSubview:font13Button];
        [stackView addArrangedSubview:font14Button];
        [stackView addArrangedSubview:font16Button];
        
    
        
    }
    return self;
}

- (void)setIdx:(NSInteger)idx {
    _idx = idx;
    [_stackView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    if (idx < _stackView.subviews.count) {
        UIButton *button = _stackView.subviews[idx];
        button.selected = YES;
        _currentButton = button;
    }
}

- (void)handleEvent:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    _currentButton.selected = NO;
    sender.selected = YES;
    _currentButton = sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectFontIndex:)]) {
        [self.delegate didSelectFontIndex:sender.tag - 1000];
    }
}


@end
