//
//  BLTrainBaseCoreLiveRecListModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainBaseCoreLiveRecListModel.h"


@implementation BLTrainBaseCoreLiveRecListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

- (void)setTutorImg:(NSString *)tutorImg {
    _tutorImg = [NSString stringWithFormat:@"%@%@", IMG_URL, tutorImg];
}

@end
