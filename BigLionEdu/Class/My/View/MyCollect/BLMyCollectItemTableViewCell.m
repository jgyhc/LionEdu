//
//  BLMyCollectItemTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyCollectItemTableViewCell.h"
#import "NSMutableAttributedString+BLTextBorder.h"
#import <YYText.h>
#import <Masonry.h>

@interface BLMyCollectItemTableViewCell  ()

@property (nonatomic, strong) YYLabel *contentlabel;
@end


@implementation BLMyCollectItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [self.contentView addSubview:self.contentlabel];
    [self.contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 48, 15, 67));
    }];
}

- (void)setModel:(BLMyMistakeQuestionModel *)model {
    _model = model;
    
    
    
    NSMutableAttributedString *att = [NSMutableAttributedString initText:model.questionType textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]  strokeColor:[UIColor colorWithRed:130/255.0 green:130/255.0 blue:176/255.0 alpha:1.0] fillColor:[UIColor colorWithRed:130/255.0 green:130/255.0 blue:176/255.0 alpha:1.0] cornerRadius:5 strokeWidth:0];
    
    NSInteger loca = att.length;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithData:[model.questionTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    //[[NSAttributedString alloc] initWithString:model.questionTitle attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0], NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W03" size:15]}]
    [att appendAttributedString:title];
    [att addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0], NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W03" size:15]} range:NSMakeRange(loca, title.length)];
    
    att.yy_lineSpacing = 8;
    self.contentlabel.attributedText = att;
    
//    
//    NSMutableAttributedString *att = [NSMutableAttributedString initText:model.questionType textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]  strokeColor:[UIColor colorWithRed:130/255.0 green:130/255.0 blue:176/255.0 alpha:1.0] fillColor:[UIColor colorWithRed:130/255.0 green:130/255.0 blue:176/255.0 alpha:1.0] cornerRadius:5 strokeWidth:0];
//    
//    NSAttributedString *title = [[NSAttributedString alloc] initWithData:[model.questionTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//    //[[NSAttributedString alloc] initWithString:model.questionTitle attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0], NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W03" size:15]}]
//    [att appendAttributedString:title];
//    [att addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0], NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W03" size:15]} range:NSMakeRange(model.questionType.length, title.length)];
//    att.yy_lineSpacing = 8;
//    self.contentlabel.attributedText = att;
        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (YYLabel *)contentlabel {
    if (!_contentlabel) {
        _contentlabel = [[YYLabel alloc] init];
        _contentlabel.numberOfLines = 0;
        _contentlabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 48 - 67;//设置最大宽度
    }
    return _contentlabel;
}

@end
