//
//  BLClassBannerTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLClassBannerTableViewCell.h"
#import <SDCycleScrollView.h>
#import "NTCatergory.h"
#import <Masonry.h>

@interface BLClassBannerTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;

@end

@implementation BLClassBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bannerView.placeholderImage = [UIImage imageNamed:@"b_placeholder"];
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    UIView *mask = [UIView new];
    mask.backgroundColor = [UIColor nt_colorWithHexString:@"#000000" alpha:0.3];
    [self.contentView insertSubview:mask aboveSubview:self.bannerView];
    [mask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(BLClassDetailModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    _timeLabel.text = [NSString stringWithFormat:@"课时：%ld课时", (long)model.courseHour];
    _bannerView.imageURLStringsGroup = @[[IMG_URL stringByAppendingString:model.coverImg?:@""]];
}

@end
