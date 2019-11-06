//
//  MJSystemLocationManager.h
//  ManJi
//
//  Created by Zgmanhui on 17/2/8.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^SystemLocationResultBlock)(NSString *locString, CLLocationCoordinate2D location ,NSError *error);
typedef void(^MJReverseGeoCoderResultBlock)(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error);


@interface MJSystemLocationManager : NSObject

@property (nonatomic) CLLocationCoordinate2D coord;

@property (nonatomic, copy) SystemLocationResultBlock block;

@property (nonatomic, copy) SystemLocationResultBlock reverseGeoCoderBlock;

+ (MJSystemLocationManager *)sharedLocation;


/**
 开始定位

 @param block 定位结果
 */
+ (void)startGetLocation:(SystemLocationResultBlock)block;

/**
 *  开始定位
 */
- (void)startLocation;
/**
 *  停止定位
 */
- (void)stopLocation;

/**
 *  定位是否开启
 */
- (BOOL)isOpenLocationWithPrompt:(BOOL)prompt;

- (void)alertOpenLocationSwitch;


@end
