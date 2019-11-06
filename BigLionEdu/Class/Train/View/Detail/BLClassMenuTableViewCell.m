//
//  BLClassMenuTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLClassMenuTableViewCell.h"
#import <JXCategoryView.h>

@interface BLClassMenuTableViewCell ()<JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@end

@implementation BLClassMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.categoryView.titles = @[@"课程介绍", @"课程表"];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorWidth = 30;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
    self.categoryView.delegate = self;
    [self.contentView addSubview:self.categoryView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateButtonClick:)]) {
        [self.delegate updateButtonClick:index];
    }
}

- (JXCategoryTitleView *)categoryView {
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.titleColor =  [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
        _categoryView.titleSelectedColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:94/255.0 alpha:1.0];
        _categoryView.titleColorGradientEnabled = YES;
//        _categoryView.titleLabelZoomEnabled = YES;
        _categoryView.titleLabelZoomScale = 1.3;
        [_categoryView setBackgroundColor:[UIColor whiteColor]];
    }
    return _categoryView;
}

@end
