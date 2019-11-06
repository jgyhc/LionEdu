//
//  BLMallScreenCollectionViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/31.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMallScreenCollectionViewCell.h"

@interface BLMallScreenCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;


@end

@implementation BLMallScreenCollectionViewCell


- (void)normaleStatus {
    [self.contentView setBackgroundColor:[UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0]];
    self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.deleteImageView.hidden = YES;
}

- (void)selectedStatus {
    [self.contentView setBackgroundColor: [UIColor colorWithRed:254/255.0 green:234/255.0 blue:225/255.0 alpha:1.0]];
    self.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    self.deleteImageView.hidden = NO;
}

- (void)setModel:(BLScreeningModel *)model {
    _model = model;
    self.titleLabel.text = model.label;
    self.deleteImageView.hidden = !model.isSelect;
    if (model.isSelect) {
        [self selectedStatus];
    } else {
        [self normaleStatus];
    }
}

@end
