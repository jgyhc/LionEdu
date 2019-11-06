//
//  ZLAreaInstance.m
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/17.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "ZLAreaInstance.h"


@implementation ZLAreaInstance


+ (instancetype)sharedInstance {
    static ZLAreaInstance *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[ZLAreaInstance alloc] init];
//        [[NSNotificationCenter defaultCenter] addObserver:obj selector:@selector(handlerNotification:) name:@"" object:nil];
    });
    return obj;
}

- (void)handlerNotification:(NSNotification *)notification {
    if (_city) {
//        _cityCode = [[ZLCityMatchingManager sharedInstance] matchingCityWithLocality:_city];
    }
}

- (void)setCity:(NSString *)city {
    _city = city;
    
//    _cityCode = [[ZLCityMatchingManager sharedInstance] matchingCityWithLocality:city];
    
    if (!_isCustom) {
        self.customCity = city;
    }
}

- (void)setArea:(NSString *)area {
    if (area != _area) {
         _area = area;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loctionAreaUpdateNotificationKey" object:nil userInfo:@{@"province":_province?_province:@"",
                                                                                                                             @"city": _city?_city:@"",
                                                                                                                             @"area":_area?_area:@""
                                                                                                                             }];
    }
}

- (void)setCustomCity:(NSString *)customCity {
    _customCity = customCity;
    if (customCity) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cityUpdtaeNotificationKey" object:nil userInfo:@{@"city": customCity}];
    }
}

@end
