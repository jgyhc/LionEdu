//
//  BLHomePageItemModel.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/21.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLHomePageItemModel.h"

@implementation BLHomePageItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

- (void)setId:(NSInteger)Id {
    _Id = Id;
    switch (Id) {
        case 11: {//教师资格证
            _content = @"名师汇 ● 名师大咖亲自授课";
            _subTextColorSting = @"#B0550C";
            _imageName = @"hp_jszgz";
        }
            break;
        case 12: {//专升本
            _content = @"名师汇 ● 名师大咖亲自授课";
            _subTextColorSting = @"#FF6B00";
            _imageName = @"hp_zsb";
        }
            break;
        case 13: {//公务员
            _content = @"名师汇 ● 名师大咖亲自授课";
            _subTextColorSting = @"#FFC144";
            _imageName = @"hp_gwy";
        }
            break;
        case 14: {//事业单位
            _content = @"名师汇 ● 名师大咖亲自授课";
            _subTextColorSting = @"#B0550C";
            _imageName = @"hp_sydw";
        }
            break;
        case 15: {//计算机&英语等级考试
            _content = @"名师汇 ● 名师大咖亲自授课";
            _subTextColorSting = @"#FF6B00";
            _imageName = @"hp_jsj";
        }
            break;
        case 16: {//教师招聘
            _content = @"名师汇 ● 名师大咖亲自授课";
            _subTextColorSting = @"#B0550C";
            _imageName = @"hp_jszgz";
        }
            break;
            
        default:
            break;
    }
    
    
}

- (NSString *)subTextColorSting {
    if (!_subTextColorSting) {
        _subTextColorSting = @"#FF6B00";
    }
    return _subTextColorSting;
}
@end
