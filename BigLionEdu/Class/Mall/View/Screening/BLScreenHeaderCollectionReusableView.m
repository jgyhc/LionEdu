//
//  BLScreenHeaderCollectionReusableView.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/31.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLScreenHeaderCollectionReusableView.h"

@implementation BLScreenHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NSString *)model {
    _model = model;
    self.titleLab.text = model;
}

@end
