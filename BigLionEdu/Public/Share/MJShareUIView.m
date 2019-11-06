//
//  ShareUIView.m
//  ManJi
//
//  Created by Zgmanhui on 2017/8/14.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import "MJShareUIView.h"
#import <Masonry.h>
#import "AdaptScreenHelp.h"

#define MJShare_UICOLOR_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static const CGFloat cancelButtonHeight = 50.00;//取消按钮高度

static const CGFloat contentHeight = 205.00;


@interface MJShareUIView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIButton * backgroundButton;

@property (nonatomic, strong) UIView * bgWindow;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *datas;

/** 行 */
@property (nonatomic, assign) NSInteger line;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIView *contentView;


@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) BOOL animationing;

@property (nonatomic, strong) UIView *lineView;
@end

@implementation MJShareUIView


- (void)initSubviewsForShareView {
    [self addSubview:self.backgroundButton];
    [self.backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    

    self.contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, contentHeight + BottomSpace());
    
    self.collectionView.frame = CGRectMake(0, 44, self.contentView.bounds.size.width, 111);
    
    [self addSubview:self.contentView];
    
    self.lineView.frame = CGRectMake(0, 44 , self.contentView.bounds.size.width, 0.5);
    
    self.cancelButton.frame = CGRectMake(0, 155, self.contentView.bounds.size.width, cancelButtonHeight);

    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.lineView];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"分享到";
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(15);
    }];
    
    [self.collectionView reloadData];
}


- (void)reloadData {
    [self.datas removeAllObjects];
    NSArray *items = nil;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberItemInShareUIView:)]) {
        items = [self.dataSource numberItemInShareUIView:self];
    }
    if (!items && items.count == 0) {
        return;
    }
    
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ShareUIModel class]]) {
            [self.datas addObject:obj];
        }
    }];
//    _line = self.datas.count / list;
//    NSInteger num = self.datas.count % list;
//    if (num != 0) {
//        _line ++;
//    }
    [self initSubviewsForShareView];
}


- (void)handelCanleEvent:(UIButton *)sender {
    [self hide];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareUICell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ShareUICell class]) forIndexPath:indexPath];
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareUIModel *model = self.datas[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareUIView:didSelectItem:)]) {
        [self.delegate shareUIView:self didSelectItem:model.type];
    }
}


#pragma mark -- show
- (void)show {
    if (_isShow || _animationing) {
        return;
    }
    _isShow = YES;
    _animationing = YES;
    [self.bgWindow addSubview:self];
    self.frame = self.bgWindow.bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.684 alpha:0.000];
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - contentHeight - BottomSpace(), [UIScreen mainScreen].bounds.size.width, 205);
        wself.backgroundColor = [UIColor colorWithWhite:0.177 alpha:0.420];
    }completion:^(BOOL finished) {
        wself.animationing = NO;
    }];
}

#pragma mark -- remove
- (void)hide {
    if (_animationing) {
        return;
    }
    _animationing = YES;
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, contentHeight);
        wself.backgroundColor = [UIColor colorWithWhite:0.684 alpha:0.000];
    } completion:^(BOOL finished) {
        wself.isShow = NO;
        wself.animationing = NO;
        [wself removeFromSuperview];
    }];
}

#pragma mark -- getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(flexibleWidth(45), flexibleWidth(45));
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 30;
        layout.sectionInset = UIEdgeInsetsMake(32, flexibleWidth(15), 0, flexibleWidth(15));
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor colorWithRed:252/255.0 green:249/255.0 blue:247/255.0 alpha:1.0]];
        [_collectionView registerClass:[ShareUICell class] forCellWithReuseIdentifier:NSStringFromClass([ShareUICell class])];
    }
    return _collectionView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.cornerRadius = 5;
        _contentView.clipsToBounds = YES;
        [_contentView setBackgroundColor:[UIColor colorWithRed:252/255.0 green:249/255.0 blue:247/255.0 alpha:1.0]];
    }
    return _contentView;
}


- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setTitleColor:MJShare_UICOLOR_HEX(0x333333) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(handelCanleEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _cancelButton;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:MJShare_UICOLOR_HEX(0xdbdbdb)];
    }
    return _lineView;
}

- (UIView *)bgWindow {
    if (!_bgWindow) {
        _bgWindow = ({
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window;
        });
    }
    return _bgWindow;
}

- (UIButton *)backgroundButton {
    if (!_backgroundButton) {
        _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backgroundButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundButton;
}

@end


@implementation ShareUICell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.frame = self.bounds;
        [self.contentView addSubview:_iconImageView];
        
        _label = [UIButton buttonWithType:UIButtonTypeCustom];
        _label.titleLabel.font = [UIFont systemFontOfSize:10];
        [_label setTitleColor:MJShare_UICOLOR_HEX(0x333333) forState:UIControlStateNormal];
        _label.backgroundColor = [UIColor whiteColor];
        _label.layer.cornerRadius = 7;
        _label.clipsToBounds = YES;
        [_label setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(14);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
    }
    return self;
}

- (void)setModel:(ShareUIModel *)model {
    _model = model;
    [_label setTitle:model.title forState:UIControlStateNormal];
    [_iconImageView setImage:[UIImage imageNamed:model.icon]];
}

@end


@implementation ShareUIModel

- (void)setType:(ShareUIViewType)type {
    _type = type;
    switch (_type) {
        case ShareUIViewTypeQQZone: {
            _title = @"空间";
            _icon = @"share_qqkj";
        }
            break;
        case ShareUIViewTypeQQ: {
            _title = @"QQ";
            _icon = @"share_qq";
        }
            break;
        case ShareUIViewTypeWechatSession: {
            _title = @"微信";
            _icon = @"share_wx";
        }
            break;
        case ShareUIViewTypeWechatTimeline: {
            _title = @"朋友圈";
            _icon = @"share_pyq";
        }
            break;
        
        case ShareUIViewTypeWeiBo: {
            _title = @"微博";
            _icon = @"share_wb";
        }
            break;
        case ShareUIViewTypeOther: {
            _title = @"";
            _icon = @"";
        }
            break;
            
        default:
            break;
    }
}

@end
