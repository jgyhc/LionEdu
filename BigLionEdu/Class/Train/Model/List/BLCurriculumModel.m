//
//  BLCurriculumModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLCurriculumModel.h"

@implementation BLCurriculumModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

- (NSString *)noteStateStr {
    if (!_noteStateStr) {
        if (![self.noteLocation isKindOfClass:[NSNull class]] && self.noteLocation.length <= 0) {
            _noteStateStr = @"";
            _isCanDownLoad = NO;
        } else if (self.isPurchase == 1 || ([self.isFree isEqualToString:@"1"] && self.price.floatValue <= 0)) {
            FKTask *task = [[FKDownloadManager manager] acquire:[IMG_URL stringByAppendingString:self.noteLocation]];
            if (task) {
                _task = task;
                _noteStateStr = @"查看讲义";
            } else {
                _noteStateStr = @"下载讲义";
            }
            _isCanDownLoad = YES;
        } else {
            _noteStateStr = @"下载讲义";
            _isCanDownLoad = NO;
        }
    }
    return _noteStateStr;
}

@end
