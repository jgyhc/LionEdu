//
//  BLTrainBannerTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainBannerTableViewCell.h"
#import "KJBannerView.h"

@interface BLTrainBannerTableViewCell ()

@property (nonatomic, strong) KJBannerView * bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation BLTrainBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bannerView = [[KJBannerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    [self.contentView addSubview:self.bannerView];
    [_bannerView setBackgroundColor:[UIColor clearColor]];
    _bannerView.imgCornerRadius = 10;
    _bannerView.autoScroll = NO;
    _bannerView.itemWidth = [UIScreen mainScreen].bounds.size.width - 30;
//    _bannerView.autoScrollTimeInterval = 2;
//    _bannerView.isZoom = YES;
    _bannerView.itemSpace = 15;
//    _bannerView.itemWidth = self.contentView.frame.size.width-120;
    _bannerView.imageType = KJBannerViewImageTypeNetIamge;

    _backgroundImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _backgroundImageView.layer.shadowOffset = CGSizeMake(0,3);
    _backgroundImageView.layer.shadowOpacity = 1;
    _backgroundImageView.layer.shadowRadius = 14;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NSArray<NSString *> *)model {
    _model = model;
    _bannerView.imageDatas = model;
}

@end
