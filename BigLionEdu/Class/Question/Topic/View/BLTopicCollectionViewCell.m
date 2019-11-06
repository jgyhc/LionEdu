//
//  BLTopicCollectionViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicCollectionViewCell.h"
#import <Masonry.h>

@interface BLTopicCollectionViewCell ()

@property (nonatomic, strong) UIView *view;

@end


@implementation BLTopicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(subView)]) {
        _view =  [self.delegate subView];
    }
    if (_view) {
        [self.contentView addSubview:_view];
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
}

@end
