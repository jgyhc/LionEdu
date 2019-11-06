//
//  BLTopicMaterialContentTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/26.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTopicMaterialContentTableViewCell.h"
#import <YYLabel.h>
#import <YYText.h>
#import "BLTopicFontManager.h"

@interface BLTopicMaterialContentTableViewCell ()

@property (weak, nonatomic) IBOutlet YYLabel *label;
@end

@implementation BLTopicMaterialContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label.numberOfLines = 0;
    _label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 30;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontDidChange) name:@"BLTopicFontDidChange" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fontDidChange {
   _model.attributedString.yy_font = [BLTopicFontManager sharedInstance].titleFont;
    _label.attributedText = _model.attributedString;
}

- (void)setModel:(BLTopicTextModel *)model {
    _model = model;
    _label.attributedText = model.attributedString;
}



@end
