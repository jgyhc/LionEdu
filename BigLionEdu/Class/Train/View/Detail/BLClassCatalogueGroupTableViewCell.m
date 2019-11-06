//
//  BLClassCatalogueGroupTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLClassCatalogueGroupTableViewCell.h"

@interface BLClassCatalogueGroupTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation BLClassCatalogueGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLClassScheduleModel *)model {
    _model = model;
    _titleLabel.text = model.courseTitle;
    _contentLabel.text = [NSString stringWithFormat:@"%ld分钟", model.totalHours];
    if (model.isOpen) {
        _iconImageView.image = [UIImage imageNamed:@"kcxq_sq"];
    }else {
        _iconImageView.image = [UIImage imageNamed:@"kcxq_zk"];
    }
}

@end
