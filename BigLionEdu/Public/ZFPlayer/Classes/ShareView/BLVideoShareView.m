//
//  BLVideoShareView.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLVideoShareView.h"
#import <Masonry.h>
#import "NTCatergory.h"
#import "BLVideoShareInfoManager.h"
#import <SDWebImage.h>
#import "MJShareManager.h"
#import <LCProgressHUD.h>

@interface BLVideoShareView ()

@property (nonatomic, strong) NSMutableArray <UIButton *> *buttons;
@property (nonatomic, strong) UIView *mask;
@property (nonatomic, strong) UILabel *downLab;
@property (nonatomic, strong) UIImage *posterImage;

@end

@implementation BLVideoShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self rt_initailizeUI];
    }
    return self;
}

- (void)rt_initailizeUI {
    UIView *mask = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:mask];
    [mask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    mask.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [mask addGestureRecognizer:tap];
    
    self.backgroundColor = [UIColor nt_colorWithHexString:@"#000000" alpha:0.7];
    NSArray *icons = @[@"share_qq", @"share_qqkj", @"share_wx", @"share_pyq", @"share_wb", @"s_d"];
    NSArray *titles = @[@"QQ", @"空间", @"微信", @"朋友圈", @"微博", @"生成海报"];
    [self addSubview:self.shareButtonsView];
    [self.shareButtonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(420.0);
        make.bottom.offset(-15);
    }];
    for (NSInteger i = 0; i < icons.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.cornerRadius = 45 / 2.0;
        
        UILabel *lable = [UILabel new];
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:12];
        lable.text = titles[i];
        lable.textAlignment = NSTextAlignmentCenter;
        if (i == icons.count - 1) {
            self.downLab = lable;
        }
        [self.shareButtonsView addSubview:button];
        [self.shareButtonsView addSubview:lable];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset((45 + 30) * i);
            make.top.offset(0);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.top.equalTo(button.mas_bottom).offset(4);
            make.width.mas_equalTo(90);
        }];
        button.tag = 400 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:self.screenImgView];
    [self.screenImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(NTWidthRatio(294), NTWidthRatio(164)));
        make.centerY.equalTo(self).offset(-20);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.posterView];
    [self.posterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(NTWidthRatio(276), NTWidthRatio(268)));
        make.top.offset(15);
        make.centerX.equalTo(self);
    }];
    self.posterView.hidden = YES;
}

-(UIImage *)screenShotView:(UIView *)view{
   UIImage *imageRet = [[UIImage alloc]init];
   UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0);
   [view.layer renderInContext:UIGraphicsGetCurrentContext()];
   imageRet = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return imageRet;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _screenImgView.image = image;
    self.posterView.screenImgView.image = image;
    self.posterView.nameLab.text = [BLVideoShareInfoManager shared].name;
    self.posterView.descLab.text = [BLVideoShareInfoManager shared].desc;
    self.posterView.onlineNumberLab.text = [BLVideoShareInfoManager shared].onlinenumber;
    self.posterView.courseNameLab.text = [BLVideoShareInfoManager shared].videoName;
    [self.posterView.avatar sd_setImageWithURL:[NSURL URLWithString:[BLVideoShareInfoManager shared].avatar] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
    
    NSString *string = [NSString stringWithFormat:@"%@ %@ %@", [BLVideoShareInfoManager shared].name, [BLVideoShareInfoManager shared].desc, [BLVideoShareInfoManager shared].onlinenumber];
    
    [[MJShareManager sharedManager] setShareParams:@{@"generalOptions":@{
                                                             @"title":[BLVideoShareInfoManager shared].videoName?:@"",
                                                             @"describe": string,
                                                             @"linkurl":@"",
                                                             @"img": @"",
                                                             @"images": @[self.image]}}];
}

- (void)buttonAction:(UIButton *)sender {
    switch (sender.tag) {
        case 400:
            [self qq];
            break;
        case 401:
            [self kj];
            break;
        case 402:
            [self wx];
            break;
        case 403:
            [self pyq];
            break;
        case 404:
            [self wb];
            break;
        case 405:
            [self hb];
            break;
        default:
            break;
    }
}

/// QQ
- (void)qq {
    [[MJShareManager sharedManager] generalShareWithType:ShareUIViewTypeQQ];
}

/// QQ空间
- (void)kj {
    [[MJShareManager sharedManager] generalShareWithType:ShareUIViewTypeQQZone];
}

/// 朋友圈
- (void)pyq {
    [[MJShareManager sharedManager] generalShareWithType:ShareUIViewTypeWechatTimeline];
}

/// 微信
- (void)wx {
    [[MJShareManager sharedManager] generalShareWithType:ShareUIViewTypeWechatSession];
}

/// 微博
- (void)wb {
    [[MJShareManager sharedManager] generalShareWithType:ShareUIViewTypeWeiBo];
}

/// 生成海报
- (void)hb {
    if ([self.downLab.text isEqualToString:@"保存到本地"]) {
        self.downLab.text = @"正在保存";
        UIImageWriteToSavedPhotosAlbum(self.posterImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    } else if ([self.downLab.text isEqualToString:@"生成海报"]){
        self.posterView.hidden = NO;
        self.screenImgView.hidden = YES;
        self.posterImage = [self screenShotView:self.posterView];
        self.downLab.text = @"保存到本地";
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [LCProgressHUD show:@"保存成功"];
        self.downLab.text = @"生成海报";
        [self hide];
    } else {
        [LCProgressHUD show:@"保存失败"];
        self.downLab.text = @"保存到本地";
    }
}
 

- (void)hide {
    self.hidden = YES;
    self.downLab.text = @"生成海报";
}

- (UIView *)shareButtonsView {
    if (!_shareButtonsView) {
        _shareButtonsView = [UIView new];
    }
    return _shareButtonsView;
}

- (UIImageView *)screenImgView {
    if (!_screenImgView) {
        _screenImgView = [UIImageView new];
        _screenImgView.contentMode = UIViewContentModeScaleAspectFill;
        _screenImgView.clipsToBounds = YES;
        _screenImgView.image = [UIImage imageNamed:@"b_placeholder"];
    }
    return _screenImgView;
}

- (BLVideoSharePosterView *)posterView {
    if (!_posterView) {
        _posterView = [BLVideoSharePosterView new];
    }
    return _posterView;
}

@end

@implementation BLVideoSharePosterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self rt_initailizeUI];
    }
    return self;
}

- (void)rt_initailizeUI {
    
    self.cornerRadius = 5.0;
    self.backgroundColor = [UIColor whiteColor];
    
    self.screenImgView = [UIImageView new];
    self.screenImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.screenImgView.clipsToBounds = YES;
    self.screenImgView.image = [UIImage imageNamed:@"b_placeholder"];
    [self addSubview:self.screenImgView];
    [self.screenImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.offset(10);
        make.size.mas_equalTo(CGSizeMake(189, 105));
    }];
    
    self.courseNameLab = [UILabel new];
    self.courseNameLab.textColor = [UIColor nt_colorWithHexString:@"#333333"];
    self.courseNameLab.font = [UIFont systemFontOfSize:14];
    self.courseNameLab.text = @"《公共基础知识》理论精讲";
    [self addSubview:self.courseNameLab];
    [self.courseNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.screenImgView.mas_bottom).offset(12);
        make.width.mas_equalTo(189);
    }];
    
    self.onlineNumberLab = [UILabel new];
    self.onlineNumberLab.textColor = [UIColor nt_colorWithHexString:@"#666666"];
    self.onlineNumberLab.font = [UIFont systemFontOfSize:12];
    self.onlineNumberLab.text = @"220人在观看";
    [self addSubview:self.onlineNumberLab];
    [self.onlineNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.courseNameLab.mas_bottom).offset(12);
        make.width.mas_equalTo(189);
    }];
    
    self.avatar = [UIImageView new];
    self.avatar.contentMode = UIViewContentModeScaleAspectFill;
    self.avatar.clipsToBounds = YES;
    self.avatar.image = [UIImage imageNamed:@"b_placeholder"];
    self.avatar.cornerRadius = 35 / 2.0;
    [self addSubview:self.avatar];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.onlineNumberLab.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    self.nameLab = [UILabel new];
    self.nameLab.textColor = [UIColor nt_colorWithHexString:@"#333333"];
    self.nameLab.font = [UIFont systemFontOfSize:13];
    self.nameLab.text = @"韩建";
    [self addSubview:self.nameLab];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).offset(8);
        make.top.equalTo(self.avatar.mas_top).offset(4);
        make.width.mas_equalTo(189);
    }];
    
    self.descLab = [UILabel new];
    self.descLab.textColor = [UIColor nt_colorWithHexString:@"#666666"];
    self.descLab.font = [UIFont systemFontOfSize:12];
    self.descLab.text = @"资深教师";
    [self addSubview:self.descLab];
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).offset(8);
        make.top.equalTo(self.nameLab.mas_bottom).offset(4);
        make.width.mas_equalTo(189);
    }];
    
    self.codeImgView = [UIImageView new];
    self.codeImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.codeImgView.clipsToBounds = YES;
    self.codeImgView.image = [UIImage imageNamed:@"d_code"];
    [self addSubview:self.codeImgView];
    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.bottom.offset(-5);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    UIImageView *logo = [UIImageView new];
    logo.image = [UIImage imageNamed:@"logo"];
    [self addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.center.equalTo(self.codeImgView);
    }];
}



@end
