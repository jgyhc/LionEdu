//
//  BLTrainBaseTitleModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainBaseTitleModel.h"
#import "ZLTableViewDelegateManager.h"


@implementation BLTrainBaseTitleModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"liveRecDTOList" : [BLTrainBaseCoreLiveRecListModel class]
             };
}

- (void)setLiveRecDTOList:(NSArray<BLTrainBaseCoreLiveRecListModel *> *)liveRecDTOList {
    _liveRecDTOList = liveRecDTOList;
    NSMutableArray *items = [NSMutableArray array];
    [liveRecDTOList enumerateObjectsUsingBlock:^(BLTrainBaseCoreLiveRecListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = self.position == 3 ?  @"BLTrainILeftItemTableViewCell" : @"BLTrainItemTableViewCell";
            rowModel.cellHeight = 126;
            rowModel.data = obj;
            rowModel;
        })];
    }];
    _items = items;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _textWidth  = [self widthOfString:title];
}
/*
 
 *此方法实用性很强，可以得到动态预编译字符串宽高。
 
 */

- (CGFloat)widthOfString:(NSString *)string{
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16]};     //字体属性，设置字体的font
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, 20);     //设置字符串的宽高  MAXFLOAT为最大宽度极限值  JPSlideBarHeight为固定高度
    
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size.width;     //此方法结合  预编译字符串  字体font  字符串宽高  三个参数计算文本  返回字符串宽度
}

@end
