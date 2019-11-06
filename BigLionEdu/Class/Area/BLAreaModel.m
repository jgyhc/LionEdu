//
//  BLAreaModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/17.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLAreaModel.h"

@implementation BLAreaModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"subAreas" : [BLAreaModel class]
             };
}

- (NSMutableArray<BLAreaModel *> *)subAreas {
    if (!_subAreas) {
        _subAreas = [NSMutableArray array];
    }
    return _subAreas;
}

@end
