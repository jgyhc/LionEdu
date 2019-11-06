//
//  BLInterestItemView.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLInterestItemView.h"

@interface BLInterestItemView ()

@end

@implementation BLInterestItemView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3;
    }
    return self;
}


- (void)setModel:(BLInterestInfoModel *)model {
    _model = model;
    _titLab.text = model.title;
    [self reloadData];
}


- (void)reloadData {
    if (_model.isSelected) {
        self.iconImageView.image = [UIImage imageNamed:@"my_wdxq_r"];
        [self setBackgroundColor:[UIColor colorWithRed:254/255.0 green:234/255.0 blue:225/255.0 alpha:1.0]];
        self.layer.borderColor = [UIColor colorWithRed:254/255.0 green:234/255.0 blue:225/255.0 alpha:1.0].CGColor;
        [self.titLab setTextColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0]];
    }else {
        self.iconImageView.image = [UIImage imageNamed:@"my_wdxq_j"];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
        [self.titLab setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
    }
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
}

//- (UILabel *)tagLabel {
//    if (!_tagLabel) {
//        _tagLabel = [self getTagViewWithText:self.model.title];
//    }
//    return _tagLabel;
//}



@end
