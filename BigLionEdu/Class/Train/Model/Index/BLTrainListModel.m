//
//  BLTrainListModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainListModel.h"

@implementation BLTrainListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"coreQuestionSets" : [BLCoreQuestionSetsModel class],
             @"moduleBanners" : [BLTrainModuleBannersModel class],
             @"coreNews" : [BLTrainCoreNewsModel class],
             @"indexFunctions" : [BLTrainIndexFunctionsModel class],
             @"baseTitleDTOS" : [BLTrainBaseTitleModel class],
             };
}

- (NSArray<NSString *> *)moduleStrBanners {
    if (!_moduleStrBanners) {
        NSMutableArray *array = [NSMutableArray array];
        [self.moduleBanners enumerateObjectsUsingBlock:^(BLTrainModuleBannersModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.img) {
                [array addObject:obj.img];
            }
        }];
        NSLog(@"%@", array);
        _moduleStrBanners = array.copy;
    }
    return _moduleStrBanners;
}

@end
