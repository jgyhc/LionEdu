//
//  BLClassMenuHeaderView.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/5.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLClassMenuHeaderView.h"
#import <JXCategoryView.h>
#import "NTCatergory.h"

@interface BLClassMenuHeaderView ()<JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@end

@implementation BLClassMenuHeaderView



- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.categoryView.titles = @[@"课程介绍", @"课程表"];
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorWidth = 30;
        lineView.indicatorLineViewColor = [UIColor nt_colorWithHexString:@"#FF7349"];
        self.categoryView.indicators = @[lineView];
        
        self.categoryView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
        self.categoryView.delegate = self;
        [self.contentView addSubview:self.categoryView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bl_selectDetail) name:@"VC_TO_DETAIL" object:nil];
    }
    return self;
}

- (void)bl_selectDetail {
    [self.categoryView selectItemAtIndex:0];
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
