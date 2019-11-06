//
//  BLTrainMenuItemView.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainMenuItemView.h"
#import <Masonry.h>
#import <YYWebImage.h>


@interface BLTrainMenuItemView ()

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation BLTrainMenuItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView;
    });
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(43);
        make.top.mas_equalTo(self.mas_top).mas_offset(17);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        label;
    });
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(9);
    }];
}

- (void)setModel:(BLTrainIndexFunctionsModel *)model {
    _model = model;
    UIImage *placeholder = nil;
    if ([model.title isEqualToString:@"题库"]) {
        placeholder = [UIImage imageNamed:@"zp_tk"];
    }
    if ([model.title isEqualToString:@"课程"]) {
        placeholder = [UIImage imageNamed:@"zp_kc"];
    }
    if ([model.title isEqualToString:@"商城"]) {
        placeholder = [UIImage imageNamed:@"zp_sc"];
    }
    
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:model.img] placeholder:placeholder];
    self.titleLabel.text = model.title;
}

@end
