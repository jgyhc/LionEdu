//
//  BLMyClassLiveTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyClassLiveTableViewCell.h"
#import <SDWebImage.h>

@implementation BLMyClassLiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameBackView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    self.nameBackView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(BLMyClassListModel *)model{
    self.titLab.text = model.title;
    self.timeLab.text =  [NSString stringWithFormat:@"开播时间:%@~%@",model.iveStartDate,model.liveEndDate];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImg]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:model.tutorName attributes:@{NSFontAttributeName: [UIFont fontWithName:@"TsangerJinKai03" size: 10],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    self.nameLab.attributedText = string;
}

@end
