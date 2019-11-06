//
//  NTCircleClockCell.m
//  NTStartget
//
//  Created by jiang on 2018/9/29.
//  Copyright © 2018年 NineTonTech. All rights reserved.
//

#import "NTCircleClockCell.h"


#import "NTCatergory.h"
#import <YYWebImage.h>
#import <Masonry.h>

@interface NTCircleClockCell ()


@property (nonatomic,strong)UIImageView *contentImg;
@property (nonatomic,strong)UIButton *deleteBtn;
@property (nonatomic,strong)UIImageView *movieImg;

@end

@implementation NTCircleClockCell

#pragma mark - InitailizeUI Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self nt_initailizeUI];
    }
    return self;
}

- (void)nt_initailizeUI{

    self.contentImg = ({
        UIImageView *img = [UIImageView new];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        img.image = NTImage(@"圈子语音");
        [self.contentView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        img;
    });
    
    self.deleteBtn = ({
        UIButton *btn = [UIButton new];
        [btn setImage:NTImage(@"zl_dele") forState:0];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:btn];
        btn.externalTouchInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(2);
            make.top.mas_offset(-1);
            make.width.height.mas_offset(16);
        }];
        btn;
    });
    
    NT_WEAKIFY(self);
    [self.deleteBtn nt_addConfig:^(__kindof UIControl * _Nonnull control) {
        NT_STRONGIFY(self);
        NT_BLOCK(self.deleteConfig, self.indexPath);
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    self.movieImg = ({
        UIImageView *img = [UIImageView new];
        img.image = NTImage(@"圈子音频符");
        [self.contentView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.height.mas_equalTo(self.mas_width).multipliedBy(0.75);
        }];
        img;
    });
    
}
#pragma mark - Add User Events
- (void)nt_addUserEvents{

}

#pragma mark - UpdateUI Methods
- (void)setModel:(NTCircleClockModel *)model {
    _model = model;

    self.movieImg.hidden = YES;
    
    
    if ([self.model isKindOfClass:[UIImage class]]) {
        self.contentImg.image = (UIImage *)self.model;
        return;
    }
    if ([self.model isKindOfClass:[NSURL class]]) {
        [self.contentImg yy_setImageWithURL:(NSURL *)self.model placeholder:NTImage(@"placeholder_circular_icon")];
        return;
    }
    if ([self.model isKindOfClass:[NSString class]]) {
        [self.contentImg yy_setImageWithURL:[NSURL URLWithString:(NSString *)self.model] placeholder:NTImage(@"placeholder_circular_icon")];
        return;
    }
    
    self.contentImg.image = self.model.contentImg;
    if (self.model.deleteType ==1) {
        self.deleteBtn.hidden = NO;
    }else if (self.model.deleteType ==0){
        self.deleteBtn.hidden = YES;
    }
    
    if (self.model.voiceType ==2) {
        self.movieImg.hidden = NO;
    }else {
        self.movieImg.hidden = YES;
    }
    
}

- (void)setShouldDelete:(BOOL)shouldDelete {
    self.deleteBtn.hidden = !shouldDelete;
}

@end

