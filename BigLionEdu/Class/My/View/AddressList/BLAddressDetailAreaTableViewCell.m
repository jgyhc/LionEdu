//
//  BLAddressDetailAreaTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAddressDetailAreaTableViewCell.h"

@interface BLAddressDetailAreaTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@end

@implementation BLAddressDetailAreaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _areaLabel.text = @"省/市/区/乡镇街道";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLAddressModel *)model {
    _model = model;
    _areaLabel.text = model.district?[NSString stringWithFormat:@"%@%@%@", model.province,model.city, model.district]:@"省/市/区/乡镇街道";
    if (model.district) {
        _areaLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }else {
        _areaLabel.textColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0];
    }
}

@end
