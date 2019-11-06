//
//  BLTopicTitleTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicTitleTableViewCell.h"
#import "BLTopicFontManager.h"

@interface BLTopicTitleTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation BLTopicTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontDidChange) name:@"BLTopicFontDidChange" object:nil];
    _titleLabel.font = [BLTopicFontManager sharedInstance].titleFont;
    _countLabel.font = [BLTopicFontManager sharedInstance].titleFont;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fontDidChange {
    _titleLabel.font = [BLTopicFontManager sharedInstance].titleFont;
    _countLabel.font = [BLTopicFontManager sharedInstance].titleFont;
}

- (void)setModel:(BLTopicModel *)model {
    _model = model;
    _titleLabel.text = model.classfierType;
    _countLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)model.idx, (long)model.totalNum];
}

@end
