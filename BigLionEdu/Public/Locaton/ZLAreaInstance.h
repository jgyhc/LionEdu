//
//  ZLAreaInstance.h
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/17.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLAreaInstance : NSObject

+ (instancetype)sharedInstance;

#pragma mark --------------------------定位获取----------------------------
@property (nonatomic, copy) NSString * province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, assign) NSInteger cityCode;

@property (nonatomic, assign) CLLocationCoordinate2D coord;

#pragma mark --------------------------自定义----------------------------
//是否是自定义的
@property (nonatomic, assign) BOOL isCustom;
//城市
@property (nonatomic, copy) NSString *customCity;


@end

NS_ASSUME_NONNULL_END
