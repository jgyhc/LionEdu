//
//  BLModuleSingleton.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLModuleSingleton.h"

@implementation BLModuleSingleton


+ (instancetype)sharedInstance {
    static BLModuleSingleton *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[BLModuleSingleton alloc] init];
    });
    return share;
}

- (void)setModules:(NSArray<BLHomePageItemModel *> *)modules {
    _modules = modules;
    NSMutableArray *titles = [NSMutableArray array];
    [_modules enumerateObjectsUsingBlock:^(BLHomePageItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj.title];
    }];
    _titles = titles;
    
}

@end
