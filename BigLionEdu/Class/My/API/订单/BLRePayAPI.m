//
//  BLRePayAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/7.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLRePayAPI.h"

@implementation BLRePayAPI


- (NSString *)methodName {
    return @"appShoppingMall/rePay";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end

@implementation BLBuyPackagePayAPI


- (NSString *)methodName {
    return @"appShoppingMall/buyPackage";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
