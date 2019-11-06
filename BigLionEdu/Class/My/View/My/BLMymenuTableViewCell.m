//
//  BLMymenuTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMymenuTableViewCell.h"

@interface BLMymenuTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *whiteView;

@end

@implementation BLMymenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(id)model {
    _model = model;
	
}

@end
