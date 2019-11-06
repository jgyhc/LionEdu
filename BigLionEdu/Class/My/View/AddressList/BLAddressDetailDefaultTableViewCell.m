//
//  BLAddressDetailDefaultTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAddressDetailDefaultTableViewCell.h"


@interface BLAddressDetailDefaultTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation BLAddressDetailDefaultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLAddressModel *)model {
    _model = model;
    _selectButton.selected = [model.isDefault isEqualToString:@"1"];
}

@end
