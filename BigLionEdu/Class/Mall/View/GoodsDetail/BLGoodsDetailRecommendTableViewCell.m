//
//  BLGoodsDetailRecommendTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGoodsDetailRecommendTableViewCell.h"
#import "NTCatergory.h"

@implementation BLGoodsDetailRecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = self.backgroundColor = [UIColor nt_colorWithHexString:@"#F2F5F5"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(NSString *)model {
    _model = model;
    self.titleLab.text = model;
}

@end
