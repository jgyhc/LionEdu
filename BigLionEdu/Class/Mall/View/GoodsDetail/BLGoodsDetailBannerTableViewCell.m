//
//  BLGoodsDetailBannerTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGoodsDetailBannerTableViewCell.h"
#import <Masonry.h>

@implementation BLGoodsDetailBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bannerScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectZero];
    self.bannerScrollView.delegate = self;
    [self.bannerContainer insertSubview:self.bannerScrollView belowSubview:self.numLab];
    [self.bannerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.bannerScrollView.placeholderImage = [UIImage imageNamed:@"b_placeholder"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLGoodsDetailModel *)model {
    _model = model;

    self.bannerScrollView.imageURLStringsGroup = model.goodsBannerUrlList;
    self.numLab.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)model.goodsBannerUrlList.count];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    self.numLab.text = [NSString stringWithFormat:@"%ld/%lu", (long)index + 1, (unsigned long)cycleScrollView.imageURLStringsGroup.count];
}


@end
