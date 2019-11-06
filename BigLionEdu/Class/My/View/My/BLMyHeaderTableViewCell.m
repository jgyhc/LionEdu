//
//  BLMyHeaderTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyHeaderTableViewCell.h"
#import "ZLUserInstance.h"
#import <YYWebImage.h>
#import "NTCatergory.h"
#import <Masonry.h>

@interface BLMyHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipIcon;
@property (weak, nonatomic) IBOutlet UILabel *defortVipLabel;

@property (nonatomic, strong) NSMutableArray <UIImageView *>*vipIcons;

@end

@implementation BLMyHeaderTableViewCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoUpdate) name:@"ZLUserInfoUpdateNotificationKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginEvent) name:@"ZLUserLoginNotificationKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutEvent) name:@"ZLUserLoginOutNotificationKey" object:nil];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.backgroundColor = [UIColor whiteColor];
    _headerImageView.image = [UIImage imageNamed:@"my_avatar"];
    UIView *avatar_bg = [UIView new];
    avatar_bg.cornerRadius = 69.0 / 2.0;
    avatar_bg.backgroundColor = [UIColor nt_colorWithHexString:@"ffffff" alpha:0.6];
    [self.contentView insertSubview:avatar_bg belowSubview:self.headerImageView];
    [avatar_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.headerImageView);
        make.size.mas_equalTo(CGSizeMake(69, 69));
    }];
    _vipIcon.hidden = YES;
    _defortVipLabel.hidden = YES;
    _vipIcons = [NSMutableArray array];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)userInfoUpdate {
    [self updateData];
}

- (void)loginEvent {
    [self updateData];
}

- (void)loginOutEvent {
    [self updateData];
}

- (void)updateData {
    self.loginLabel.hidden = [ZLUserInstance sharedInstance].isLogin;
    self.phoneLabel.hidden = ![ZLUserInstance sharedInstance].isLogin;
    self.titleLabel.hidden = ![ZLUserInstance sharedInstance].isLogin;
    self.phoneImageView.hidden = ![ZLUserInstance sharedInstance].isLogin;
    
    [self.vipIcons enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    
    if ([ZLUserInstance sharedInstance].isLogin) {
        if ([ZLUserInstance sharedInstance].nickname && [ZLUserInstance sharedInstance].nickname.length > 0) {
            self.titleLabel.text = [ZLUserInstance sharedInstance].nickname;
        } else if ([ZLUserInstance sharedInstance].mobile && [ZLUserInstance sharedInstance].mobile.length > 0) {
            self.titleLabel.text = [ZLUserInstance sharedInstance].mobile;
        } else {
            self.titleLabel.text = @"请登录";
        }
        if ([ZLUserInstance sharedInstance].mobile && [ZLUserInstance sharedInstance].mobile.length > 0) {
            self.phoneLabel.text = [ZLUserInstance sharedInstance].mobile;
            self.phoneImageView.hidden = NO;
        }
        NSLog(@"_________%@", [ZLUserInstance sharedInstance].photo);
        [_headerImageView yy_setImageWithURL:[NSURL URLWithString:[ZLUserInstance sharedInstance].photo] placeholder:[UIImage imageNamed:@"my_avatar"]];
        
        NSArray *levelList = [ZLUserInstance sharedInstance].levelList;
//        [self.vipIcons make]
        if (levelList.count > 0) {
            _vipIcon.hidden = YES;
            _defortVipLabel.hidden = YES;
            [levelList enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSURL *icon = [NSURL URLWithString: [[NSString stringWithFormat:@"%@%@", IMG_URL, obj[@"icon"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
                               ];
                UIImageView *iconView = nil;
                
                if (idx < self.vipIcons.count) {
                    iconView = self.vipIcons[idx];
                    iconView.hidden = NO;
                }else {
                    iconView = [UIImageView new];
                    [self.vipIcons addObject:iconView];
                    [self.contentView addSubview:iconView];
                    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(_vipIcon.mas_left).mas_offset(30 * idx);
                        make.centerY.mas_equalTo(_vipIcon);
                        make.width.mas_offset(20);
                        make.height.mas_offset(23);
                    }];
                }
                [iconView yy_setImageWithURL:icon placeholder:[UIImage imageNamed:@"my_vip_qt"]];
            }];
        }else {
            _vipIcon.hidden = NO;
            _defortVipLabel.hidden = NO;
        }
        
    }else {
        [_headerImageView setImage:[UIImage imageNamed:@"my_avatar"]];
        _vipIcon.hidden = NO;
        _defortVipLabel.hidden = NO;
    }
}

- (void)setModel:(id)model {
    _model = model;
    [self updateData];
}

@end
