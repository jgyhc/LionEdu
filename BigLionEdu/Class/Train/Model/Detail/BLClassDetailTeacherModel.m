//
//  BLClassDetailTeacherModel.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLClassDetailTeacherModel.h"

@implementation BLClassDetailTeacherModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"descriptionString": @[@"description", @"descriptionString"]};
}



- (void)setHeadImg:(NSString *)headImg {
    _headImg = [NSString stringWithFormat:@"%@%@", IMG_URL, headImg];
}

@end
