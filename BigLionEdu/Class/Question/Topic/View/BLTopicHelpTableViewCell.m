//
//  BLTopicHelpTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicHelpTableViewCell.h"
#import "BLTopicFontManager.h"

@interface BLTopicHelpTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation BLTopicHelpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_helpButton setTitle:@"?" forState:UIControlStateNormal];
    _helpButton.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontDidChange) name:@"BLTopicFontDidChange" object:nil];
}

- (void)fontDidChange {
    _contentLabel.font = [BLTopicFontManager sharedInstance].contentFont;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLTopicOptionModel *)model {
    _model = model;
    _helpButton.selected = model.isSelect;
    if (model.isSelect) {
        [_helpButton setTitle:@"" forState:UIControlStateNormal];
    }else {
        [_helpButton setTitle:@"?" forState:UIControlStateNormal];
    }
}

@end
