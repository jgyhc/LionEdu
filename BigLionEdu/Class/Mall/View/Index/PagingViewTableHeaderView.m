//
//  PagingViewTableHeaderView.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "PagingViewTableHeaderView.h"

@interface PagingViewTableHeaderView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect imageViewFrame;
@end

@implementation PagingViewTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sc_bj"]];
        self.imageView.clipsToBounds = YES;
        
        self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];

        self.imageViewFrame = self.imageView.frame;

    }
    return self;
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
//    CGRect frame = self.imageViewFrame;
//    frame.size.height -= contentOffsetY;
//    frame.origin.y = contentOffsetY;
//    self.imageView.frame = frame;
}


@end