//
//  BLAreaManager.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/17.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLAreaManager.h"
#import "BLGetAllAreaAPI.h"
#import <YYCache.h>
#import <YYModel.h>

@interface BLAreaManager ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (nonatomic, strong) BLGetAllAreaAPI * getAllAreaAPI;

@property (nonatomic, strong) NSArray<BLAreaModel *> * areaList;

@property (nonatomic, strong) YYCache *cache;
@end

@implementation BLAreaManager

+ (instancetype)sharedInstance {
    static BLAreaManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BLAreaManager alloc] init];
        id allArea = [manager.cache objectForKey:@"AllArea"];
        manager.areaList = [NSArray yy_modelArrayWithClass:[BLAreaModel class] json:allArea];
        [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(loctionAreaUpdate:) name:@"loctionAreaUpdateNotificationKey" object:nil];
    });
    return manager;
}

- (void)loctionAreaUpdate:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
//    @{@"province":_province?_province:@"",
//      @"city": _city?_city:@"",
//      @"area":_area?_area:@""
//      }
    NSString *province = [userInfo objectForKey:@"province"];
    NSString *city = [userInfo objectForKey:@"city"];
    NSString *area = [userInfo objectForKey:@"area"];
    [_areaList enumerateObjectsUsingBlock:^(BLAreaModel * _Nonnull provinceObj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([province containsString:provinceObj.areaName]) {
            self.provinceAreaModel = provinceObj;
            [provinceObj.subAreas enumerateObjectsUsingBlock:^(BLAreaModel * _Nonnull cityObj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([city containsString:cityObj.areaName]) {
                    self.cityAreaModel = cityObj;
                    cityObj.provinceString = provinceObj.areaName;
                    cityObj.provinceId = provinceObj.areaId;
                    [cityObj.subAreas enumerateObjectsUsingBlock:^(BLAreaModel * _Nonnull areaObj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([area containsString:areaObj.areaName]) {
                            self.areaAreaModel = areaObj;
                            areaObj.provinceString = provinceObj.areaName;
                            areaObj.provinceId = provinceObj.areaId;
                            areaObj.cityString = cityObj.cityString;
                            areaObj.cityId = cityObj.areaId;
                        }
                    }];
                }
            }];
        }
    }];
    
    
}


- (void)startRequestArea {
    if (self.areaList.count == 0 && !self.getAllAreaAPI.isLoading) {
        [self.getAllAreaAPI loadData];
    }
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getAllAreaAPI isEqual:manager]) {
        return nil;
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getAllAreaAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray<BLAreaModel *> *array = [NSArray yy_modelArrayWithClass:[BLAreaModel class] json:[data objectForKey:@"data"]];
            NSMutableArray<BLAreaModel *> *list = [array mutableCopy];
            //先筛选出第一级 省
            NSMutableArray<BLAreaModel *> * topList = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(BLAreaModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.areaParentId == 0) {
                    [topList addObject:obj];
                }
            }];
            [list removeObjectsInArray:topList];
            //市
            NSMutableArray *cityObjs = [NSMutableArray array];
            [topList enumerateObjectsUsingBlock:^(BLAreaModel *  _Nonnull parentObj, NSUInteger idx, BOOL * _Nonnull stop) {
                [list enumerateObjectsUsingBlock:^(BLAreaModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (parentObj.areaId == obj.areaParentId) {
                        [parentObj.subAreas addObject:obj];
                        [cityObjs addObject:obj];
                    }
                }];
            }];
            [list removeObjectsInArray:cityObjs];
            
            //区
            NSMutableArray *areaObjs = [NSMutableArray array];
            [topList enumerateObjectsUsingBlock:^(BLAreaModel *  _Nonnull provinceObj, NSUInteger idx, BOOL * _Nonnull stop) {
                [provinceObj.subAreas enumerateObjectsUsingBlock:^(BLAreaModel * _Nonnull cityObj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [list enumerateObjectsUsingBlock:^(BLAreaModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (cityObj.areaId == obj.areaParentId) {
                            [cityObj.subAreas addObject:obj];
                            [areaObjs addObject:obj];
                        }
                    }];
                }];
            }];
            [list removeObjectsInArray:areaObjs];
            self.areaList = topList;
            [self.cache setObject:[self.areaList yy_modelToJSONObject] forKey:@"AllArea"];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (NSString *)getDocumentPathWithFirstName:(NSString *)firstName {
    NSArray *userPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [userPaths objectAtIndex:0];
    if (firstName) {
        return [NSString stringWithFormat:@"%@/%@", path, firstName];
    }
    return path;
}

- (BLGetAllAreaAPI *)getAllAreaAPI {
    if (!_getAllAreaAPI) {
        _getAllAreaAPI = [[BLGetAllAreaAPI alloc] init];
        _getAllAreaAPI.mj_delegate = self;
        _getAllAreaAPI.paramSource = self;
    }
    return _getAllAreaAPI;
}

- (YYCache *)cache {
    if (!_cache) {
        _cache = [[YYCache alloc] initWithPath:[self getDocumentPathWithFirstName:@"area"]];
    }
    return _cache;
}
@end
