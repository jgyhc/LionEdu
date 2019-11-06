//
//  BLAddressListTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAddressListTableViewCell.h"

@interface BLAddressListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *defalutButton;
@property (weak, nonatomic) IBOutlet UIView *silderView;

@end

@implementation BLAddressListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)deleteEvent:(id)sender {
    [self.delegate BLAddressListTableViewCellDelete:self.model];
}

- (IBAction)editEvent:(id)sender {
    [self.delegate BLAddressListTableViewCellEdit:self.model];
}

- (void)setModel:(BLAddressModel *)model {
    _model = model;
    _nameLabel.text = model.name;
    _addressLabel.text = [NSString stringWithFormat:@"%@%@%@ %@", model.province, model.city, model.district, model.detail];
    _defalutButton.hidden = [model.isDefault isEqualToString:@"0"];
    if (_model.selected) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:253/255.0 green:244/255.0 blue:238/255.0 alpha:1.0]];
        self.silderView.hidden = NO;
    }else {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        self.silderView.hidden = YES;
    }
}

@end
