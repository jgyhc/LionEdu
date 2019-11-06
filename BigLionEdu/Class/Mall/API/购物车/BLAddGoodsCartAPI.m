//
//  BLAddGoodsCartAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLAddGoodsCartAPI.h"

@implementation BLAddGoodsCartAPI

- (NSString *)methodName {
    return @"appShoppingMall/insertGoodsCart";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePut;
}

- (BOOL)isHideProgressHUDWhenSuccess {
    return YES;
}

@end
