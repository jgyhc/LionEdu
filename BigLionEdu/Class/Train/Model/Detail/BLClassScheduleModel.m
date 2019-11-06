//
//  BLClassScheduleModel.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLClassScheduleModel.h"

@implementation BLClassScheduleModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"liveRecCourseDTOS" : [BLClassScheduleItemModel class]};
}
@end
