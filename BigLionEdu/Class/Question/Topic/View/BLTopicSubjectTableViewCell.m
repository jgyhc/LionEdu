//
//  BLTopicSubjectTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicSubjectTableViewCell.h"
#import <YYText.h>
#import "AdaptScreenHelp.h"
#import <Masonry.h>
#import "NSMutableAttributedString+BLTextBorder.h"
#import "BLTopicFontManager.h"

@interface BLTopicSubjectTableViewCell ()

@property (nonatomic, strong) YYLabel *titleLabel;

@end

@implementation BLTopicSubjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(18, 15, 18, 15));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontDidChange) name:@"BLTopicFontDidChange" object:nil];
}

- (NSAttributedString *)title {
    NSMutableAttributedString *att = [NSMutableAttributedString initText:self.model.type?self.model.type:@"题型" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]  strokeColor:[UIColor colorWithRed:255/255.0 green:87/255.0 blue:84/255.0 alpha:1.0] fillColor:[UIColor colorWithRed:255/255.0 green:87/255.0 blue:84/255.0 alpha:1.0] cornerRadius:5 strokeWidth:0];
    
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithData:[self.model.title?self.model.title:@"" dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil]];
    titleAttributedString.yy_font = [BLTopicFontManager sharedInstance].titleFont;
    titleAttributedString.yy_color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [att yy_appendString:@"  "];
    [att appendAttributedString:titleAttributedString];
    att.yy_lineSpacing = 8;
    return att;
}

- (void)fontDidChange {
    _titleLabel.attributedText = [self title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLTopicModel *)model {
    _model = model;
    _titleLabel.attributedText = [self title];
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 30;//设置最大宽度
    }
    return _titleLabel;
}
@end
