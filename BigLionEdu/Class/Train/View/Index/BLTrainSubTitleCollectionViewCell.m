//
//  BLTrainSubTitleCollectionViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/20.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainSubTitleCollectionViewCell.h"

@interface BLTrainSubTitleCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BLTrainSubTitleCollectionViewCell

- (void)setModel:(BLTrainBaseTitleModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    if (model.isSelect) {
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }else {
        _titleLabel.textColor = [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
    }
}

@end
