//
//  BLMockItemTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/27.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLMockItemTableViewCell.h"

@interface BLMockItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *tagButton;

@end

@implementation BLMockItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** 1.未报名、2、已报名、3、已考试 */
- (void)setModel:(BLMockItemModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    _contentLabel.text = [NSString stringWithFormat:@"大赛时间：%@", model.timeString];
    [_tagButton setTitle:model.status forState:UIControlStateNormal];
    if ([model.status isEqualToString:@"2"]) {
        [_tagButton setTitle:@"已报名" forState:UIControlStateNormal];
//        [_tagButton setBackgroundColor:[UIColor colorWithRed:230/255.0 green:53/255.0 blue:53/255.0 alpha:1.0]];
        [_tagButton setBackgroundImage:[UIImage imageNamed:@"mklb_rsbj"] forState:UIControlStateNormal];
        
    }else if([model.status isEqualToString:@"1"]) {
        [_tagButton setTitle:@"未报名" forState:UIControlStateNormal];
//        [_tagButton setBackgroundColor:[UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0]];
        [_tagButton setBackgroundImage:[UIImage imageNamed:@"mklb_hsbj"] forState:UIControlStateNormal];
    }else {
        [_tagButton setTitle:@"已考试" forState:UIControlStateNormal];
//        [_tagButton setBackgroundColor:[UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0]];
        [_tagButton setBackgroundImage:[UIImage imageNamed:@"mklb_hsbj"] forState:UIControlStateNormal];
    }
}

@end
