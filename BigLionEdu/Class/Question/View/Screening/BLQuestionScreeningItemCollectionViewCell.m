//
//  BLQuestionScreeningItemCollectionViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/18.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLQuestionScreeningItemCollectionViewCell.h"

@interface BLQuestionScreeningItemCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation BLQuestionScreeningItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BLScreeningItemModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    BOOL select = model.select;
    if (select) {
        self.contentView.backgroundColor = [UIColor colorWithRed:254/255.0 green:234/255.0 blue:225/255.0 alpha:1.0];
        _selectImageView.hidden = NO;
    }else {
        self.contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
        _selectImageView.hidden = YES;
    }
}

@end
