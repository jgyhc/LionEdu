//
//  BLClassDetailTeacherCollectionViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLClassDetailTeacherCollectionViewCell.h"
#import <YYWebImage.h>

@interface BLClassDetailTeacherCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *technicalLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation BLClassDetailTeacherCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BLClassDetailTeacherModel *)model {
    _model = model;
    [_headerImageView yy_setImageWithURL:[NSURL URLWithString:model.headImg] placeholder:nil];
    _nameLabel.text = model.name;
    _technicalLabel.text = model.tutorTitle;
    _contentLabel.text = model.descriptionString;
}

@end
