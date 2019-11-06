//
//  BLNewsDTOListModel.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/3.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLNewsDTOListModel.h"

@implementation BLNewsDTOListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}
@end
