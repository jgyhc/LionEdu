//
//  BLTopicAnalysisContentTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicAnalysisContentTableViewCell.h"
#import <YYLabel.h>
#import "BLTopicFontManager.h"
#import <YYText.h>
#import "NSMutableAttributedString+BLTextBorder.h"

@interface BLTopicAnalysisContentTableViewCell ()

@property (weak, nonatomic) IBOutlet YYLabel *label;

@end

@implementation BLTopicAnalysisContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label.numberOfLines = 0;
    _label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 30;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontDidChange) name:@"BLTopicFontDidChange" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fontDidChange {
    if (!_model.tagAttributedString) {
        _model.attributedString.yy_font = [BLTopicFontManager sharedInstance].titleFont;
    }else {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:_model.tagAttributedString];
        att.yy_lineSpacing = 8;
        _model.contentAttributedString.yy_font = [BLTopicFontManager sharedInstance].titleFont;
        [att appendAttributedString:_model.contentAttributedString];
        _model.attributedString = att;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateCellHeight:cell:)]) {
        [self.delegate updateCellHeight:0 cell:self];
    }
}


- (void)setModel:(BLTopicTextModel *)model {
    _model = model;
    if (model.attributedString) {
        _label.attributedText = model.attributedString;
    }else {
        _label.text = model.text;
    }
    
}

@end
