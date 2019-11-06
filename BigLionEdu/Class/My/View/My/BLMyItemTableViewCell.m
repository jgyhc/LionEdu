//
//  BLMyItemTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyItemTableViewCell.h"

@interface BLMyItemTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BLMyItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NSDictionary *)model {
    _model = model;
    _iconImageView.image = [UIImage imageNamed:[model objectForKey:@"icon"]];
    _titleLabel.text = [model objectForKey:@"title"];
	
}

@end
