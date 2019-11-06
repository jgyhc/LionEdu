
//
//  MJSystemLocationManager.m
//  ManJi
//
//  Created by Zgmanhui on 17/2/8.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import "MJSystemLocationManager.h"
#import "TQLocationConverter.h"
#import "ZLAreaInstance.h"


@interface MJSystemLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLGeocoder *revGeo;//反编码
@end

@implementation MJSystemLocationManager

+ (MJSystemLocationManager *)sharedLocation
{
    static MJSystemLocationManager *location = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        location = [[self alloc] init];
    });
    return location;
}

+ (void)startGetLocation:(SystemLocationResultBlock)block {
    MJSystemLocationManager *location = [MJSystemLocationManager sharedLocation];
    [location startGetLocation:block];
}

- (void)startGetLocation:(SystemLocationResultBlock)block {
    self.block = block;
    [self startLocation];
}

- (void)alertOpenLocationSwitch {
//    MJAlertView *view = [[MJAlertView alloc] initWithTitle:@"提示" content:@"您好像没有开启定位服务哦，去开启一下吧！" buttons:@[@"取消", @"去开启"] tapBlock:^(MJAlertView * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
//        if ([title isEqualToString:@"去开启"]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }
//    }];
//    [view show];
}

- (BOOL)isOpenLocationWithPrompt:(BOOL)prompt {
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined://定位未作出选择
                if (prompt) {
                    [self alertOpenLocationSwitch];
                }
                return NO;
                break;
            case kCLAuthorizationStatusDenied://拒绝定位
                if (prompt) {
                    [self alertOpenLocationSwitch];
                }
                return NO;
                break;
            default:
                return YES;
                break;
        }
    }
    return YES;
}

/**
 *  开始定位
 */
- (void)startLocation {
    if (![self isOpenLocationWithPrompt:NO]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
}
/**
 *  停止定位
 */
- (void)stopLocation {
    [self.locationManager  stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    CLLocationCoordinate2D coor = [TQLocationConverter transformFromWGSToBaidu:coordinate];
    self.coord = coordinate;
    [ZLAreaInstance sharedInstance].coord = coor;
//    [[MJAreaInfoInstance sharedAreaInfo] updateCoord:[NSString stringWithFormat:@"%f,%f", coor.longitude, coor.latitude]];
    [self reverseGeoCoderWithLocation:coordinate block:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error && [placemarks count] > 0) {
            CLPlacemark *obj = [placemarks objectAtIndex:0];
//            NSArray *arr = [obj.addressDictionary objectForKey:@"FormattedAddressLines"];
            NSString *State = [obj.addressDictionary objectForKey:@"State"];
            if (State.length == 0) {
                State = obj.locality;
            }
//            NSString *string = [NSString stringWithFormat:@"%@,%@,%@,%@", State, obj.locality, obj.subLocality, @"全部"];
//
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZLAreaInstance sharedInstance].province = State;
                [ZLAreaInstance sharedInstance].city = obj.locality;
                [ZLAreaInstance sharedInstance].area = obj.subLocality;
            });
            
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    [self stopLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.userInfo);
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    

}

#pragma mark -- 反编码
- (void)reverseGeoCoderWithLocation:(CLLocationCoordinate2D)coordinate block:(MJReverseGeoCoderResultBlock)block {
    CLLocation *c = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //创建位置
    [self.revGeo reverseGeocodeLocation:c completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (block) {
            block(placemarks, error);
        }
    }];
}

#pragma mark -- getter
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = 100;//设置定位距离过滤参数 (当本次定位和上次定位之间的距离大于或等于这个值时，调用代理方法)
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (CLGeocoder *)revGeo {
    if (!_revGeo) {
        _revGeo = [[CLGeocoder alloc] init];
    }
    return _revGeo;
}

@end
