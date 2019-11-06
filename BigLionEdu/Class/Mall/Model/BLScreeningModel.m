//
//  BLScreeningModel.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLScreeningModel.h"

@implementation BLScreeningModel

- (instancetype)initWithId:(NSString *)Id label:(NSString *)label {
    self = [super init];
    if (self) {
        _Id = Id;
        _label = label;
    }
    return self;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @"id"};
}

@end
