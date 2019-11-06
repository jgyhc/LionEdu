//
//  BLQuestionScreeningTopCollectionViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/18.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLQuestionScreeningTopCollectionViewCell.h"

@interface BLQuestionScreeningTopCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BLQuestionScreeningTopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)backEvent:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBackEvent)]) {
        [self.delegate didClickBackEvent];
    }
}

- (void)setModel:(BLAreaModel *)model {
    _model = model;
    _titleLabel.text = model.areaName;
}

@end
