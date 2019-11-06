//
//  BLGoodsDetailModel.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/21.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGoodsDetailModel.h"
#import "NTCatergory.h"

@implementation BLGoodsDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"groupLists": [BLGoodsDetailGroupModel class],
             @"goodsInfoList": [BLGoodsDetailVideoModel class],
             @"goodsList": [BLGoodsModel class],
             @"tutorDTOS": [BLGoodsDetailSXModel class],
             @"goodsBannerList": [BLGoodsDetailBannerModel class]
    };
}

- (NSArray<NSString *> *)goodsBannerUrlList {
    if (!_goodsBannerUrlList) {
        NSMutableArray *arr = [NSMutableArray array];
        for (BLGoodsDetailBannerModel *obj in self.goodsBannerList) {
            [arr addObject:[IMG_URL stringByAppendingFormat:obj.img?:@""]];
        }
        _goodsBannerUrlList = arr.copy;
    }
    return _goodsBannerUrlList;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bookIntroduceHeight = 200.0;
        _catalogHeight = 200.0;
    }
    return self;
}

- (void)setCatalog:(NSString *)catalog {
    NSString *width = [NSString stringWithFormat:@"<img style=\"max-width:%fpx; height:auto;\"", NT_SCREEN_WIDTH - 20];
    catalog  = [catalog stringByReplacingOccurrencesOfString:@"<img" withString:width];
    _catalog = catalog;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[catalog dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [attrString setYy_font:[UIFont systemFontOfSize:14]];
        CGFloat height = [attrString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        self.catalogAttr = attrString;
        self.catalogHeight = height + 50;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.refreshHandler();
        });
    });
}



- (void)setBookIntroduce:(NSString *)bookIntroduce {
    NSString *width = [NSString stringWithFormat:@"<img style=\"max-width:%fpx;height:auto;\"", NT_SCREEN_WIDTH - 20];
    bookIntroduce  = [bookIntroduce stringByReplacingOccurrencesOfString:@"<img" withString:width];
    _bookIntroduce = bookIntroduce;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[bookIntroduce dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [attrString setYy_font:[UIFont systemFontOfSize:14]];
        CGFloat height = [attrString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        self.bookIntroduceAttr = attrString;
        self.bookIntroduceHeight = height + 50;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.refreshHandler();
        });
    });
}

@end


@implementation BLGoodsDetailGroupModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id" :@"id"};
}

- (void)setIsEnd:(BOOL)isEnd {
    _isEnd = isEnd;
}

@end

/**
 * 赠送的视频
 */
@implementation BLGoodsDetailVideoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @"id"};
}


@end


/**
 * 推荐狮享
 */
@implementation BLGoodsDetailSXModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc": @"description"};
}

@end


/**
 * banner
 */
@implementation BLGoodsDetailBannerModel

@end
