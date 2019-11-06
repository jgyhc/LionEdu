//
//  BLTimeItemTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/17.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTimeItemTableViewCell.h"

@interface BLTimeItemTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation BLTimeItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLTimeItemModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    _selectImageView.hidden = !model.selected;
}

@end
