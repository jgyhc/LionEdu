//
//  BLAddressModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAddressModel.h"

@implementation BLAddressModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isDefault = @"0";
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

- (void)setIsDefault:(NSString *)isDefault {
    _isDefault = isDefault;
}

@end
