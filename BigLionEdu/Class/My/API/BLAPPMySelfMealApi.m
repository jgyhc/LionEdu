//
//  BLAPPMySelfMealApi.m
//  BigLionEdu
//
//  Created by mac on 2019/9/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMySelfMealApi.h"

@implementation BLAPPMySelfAllMealApi
- (NSString *)methodName {
    return @"appMyself/getAppAllPackageInfo";
    
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end

@implementation BLAPPCanBuyCheckApi
- (NSString *)methodName {
    return @"appShoppingMall/canBuyCheckByModelId";
    
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)isShowProgressHUD {
    return NO;
}

@end

@implementation BLAPPMySelfMyMealApi
- (NSString *)methodName {
    return @"appMyself/getAppMyPackageInfo";
    
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end

@implementation BLAPPMySelfMyInvalidMealApi
- (NSString *)methodName {
    return @"appMyself/getAppMyInvalidPackage";
    
}

- (BOOL)isShowProgressHUD {
    return NO;
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
