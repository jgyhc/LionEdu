//
//  BLMyMealBannerCell.m
//  BigLionEdu
//
//  Created by OrangesAL on 2019/10/13.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLMyMealBannerCell.h"
#import <Masonry.h>
#import "NTCatergory.h"
#import "ZLFactory.h"
#import "BLMyMealModel.h"

@interface BLMyMealBannerCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *flagImage;
@property (nonatomic, strong) CAGradientLayer *bgLayer;

@end

@implementation BLMyMealBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [ZLFactory labelWithFont:[UIFont systemFontOfSize:19] textColor:[UIColor whiteColor]];
        _timeLabel = [ZLFactory labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
        _flagImage = [[UIImageView alloc] initWithImage:NTImage(@"tc_hz")];
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_flagImage];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(45);
            make.left.mas_offset(16);
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-70);
            make.left.mas_offset(16);
        }];
        
        [_flagImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-4);
            make.centerY.mas_offset(-12.5);
        }];
        
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:217/255.0 blue:120/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0].CGColor];
        gl.cornerRadius = 10;
        gl.locations = @[@(0.0),@(1.0)];
        
        [self.contentView.layer addSublayer:gl];
        [self.contentView.layer insertSublayer:gl atIndex:0];
        _bgLayer = gl;
        
        
        gl.shadowColor = [UIColor colorWithRed:208/255.0 green:95/255.0 blue:13/255.0 alpha:0.62].CGColor;
        gl.shadowOffset = CGSizeMake(0.1,8);
        gl.shadowOpacity = 1;
        gl.shadowRadius = 8;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgLayer.frame = CGRectMake(0, 0, self.nt_width, self.nt_height - 25);
}

- (void)setModel:(BLMyMyMealModel *)model {
    
    _titleLabel.text = model.name;
    _timeLabel.text = model.endDate;
    
}

@end
