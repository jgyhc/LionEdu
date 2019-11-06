//
//  BLMessageTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/18.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMessageTypeTableViewCell.h"
#import <SDWebImage.h>
#import "NTCatergory.h"
#import <Masonry.h>

@implementation BLMessageTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.inconImageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.numberLab = [UILabel new];
//    self.numberLab.backgroundColor = [UIColor redColor];
//    self.numberLab.cornerRadius = 6.0;
//    self.numberLab.textAlignment = NSTextAlignmentCenter;
//    self.numberLab.textColor = [UIColor whiteColor];
//    self.numberLab.font = [UIFont systemFontOfSize:10];
//    [self.contentView addSubview:self.numberLab];
//    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.inconImageView.mas_right).offset(-6);
//        make.top.equalTo(self.inconImageView.mas_top).offset(3);
//        make.size.mas_equalTo(CGSizeMake(12, 12));
//    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(BLMyNewsTypeModel *)model{
    NSLog(@"%@", [IMG_URL stringByAppendingString:model.icon?:@""]);
    [self.inconImageView sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:model.icon?:@""]] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
    self.titLab.text = model.title;
    self.desLab.text = model.customDescription?:@"暂无消息";
    self.timeLab.text = @"";
    if ([model.title containsString:@"系统"]) {
        self.bg.backgroundColor = [UIColor nt_colorWithHexString:@"#FFB900"];
//        [self.inconImageView setImage:[UIImage imageNamed:@"xtxx"]];
    } else if ([model.title containsString:@"推送"]) {
//        [self.inconImageView setImage:[UIImage imageNamed:@"xxts"]];
        self.bg.backgroundColor = [UIColor nt_colorWithHexString:@"#FF6B00"];
    } else {
//        [self.inconImageView setImage:[UIImage imageNamed:@"fk"]];
        self.bg.backgroundColor = [UIColor nt_colorWithHexString:@"#74B1E9"];
    }
}

@end
