//
//  BLMealBannerTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/13.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMealBannerTableViewCell.h"
#import "BLHomePageItemModel.h"
#import "AdaptScreenHelp.h"
#import "KJBannerView.h"
#import "BLMyMealModel.h"
#import "NTCatergory.h"
#import "BLMyMealBannerCell.h"

@interface BLMealBannerTableViewCell ()<KJBannerViewDelegate>
//@property (weak, nonatomic) IBOutlet KJBannerView *bannerView;

@property (nonatomic, strong) KJBannerView *bannerView;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation BLMealBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//
//    _bannerView.pagingEnabled = YES;
//    _bannerView.type = iCarouselTypeRotary;
//    _bannerView.dataSource = self;
//    _bannerView.delegate = self;
//    _bannerView.clipsToBounds = YES;
//    _bannerView.scrollOffset = 20;
    _bannerView = [[KJBannerView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 171)];
    [self.contentView addSubview:self.bannerView];
    _bannerView.imgCornerRadius = 10;
    _bannerView.autoScroll = NO;
    _bannerView.itemWidth = [UIScreen mainScreen].bounds.size.width - 72;
    _bannerView.autoScrollTimeInterval = 2;
    _bannerView.isZoom = YES;
    _bannerView.itemSpace = 10;
    _bannerView.imageType = KJBannerViewImageTypeMix;
    _bannerView.itemClass = [BLMyMealBannerCell class];
    _bannerView.delegate = self;

}

- (void)setModel:(NSArray *)model {
    _bannerView.imageDatas = model;
}

- (void)kj_BannerView:(KJBannerView *)banner SelectIndex:(NSInteger)index{
    if (self.clickBlock) {
        self.clickBlock(index);
    }
}

- (void)kj_BannerView:(KJBannerView *)banner showIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerDidChangeIndex:)]) {
        [self.delegate bannerDidChangeIndex:index];
    }
}

//
//#pragma mark - <iCarouselDataSource>
//
//- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
//    return self.datas.count;
//}
//
//
//- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
//    //    switch (option) {
//    //        case iCarouselOptionWrap:
//    //            return NO;
//    //        default:
//    //            return YES;
//    //    }
//    return value;
//}
//
//- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable DQHomePageItemView *)view {
//
//    if (view == nil) {
//        view = [[NSBundle mainBundle] loadNibNamed:@"DQHomePageItemView" owner:nil options:nil].firstObject;
//        //        view = [[NSBundle mainBundle] loadNibNamed:@"ZLPosterView" owner:nil options:nil].firstObject;
//        view.bounds = CGRectMake(0, 0, self.bannerView.bounds.size.width  - 72, 142);
//    }
//    view.model = self.datas[index];
//    return view;
//
//}
//
////
////- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform atIdx:(NSInteger)idx{
////
////    static CGFloat max_sacle = 1.0f;
////    static CGFloat min_scale = 0.575f;
////    if (offset <= 1 && offset >= -1) {
////        float tempScale = offset < 0 ? 1 + offset : 1 - offset;
////        float slope = (max_sacle - min_scale) / 1;
////
////        CGFloat scale = min_scale + slope * tempScale;
////        transform = CATransform3DScale(transform, scale, scale, 1);
////    }else{
////        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
////    }
////
////    return CATransform3DTranslate(transform, offset * (self.bannerView.bounds.size.width  - 72) * 1.1, 0.0, 0.0);
////}
//
//- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index {
//    return YES;
//}
//
//- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
//    NSLog(@"选中了%ld", index);
//}
//
//- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
//
//}

@end
