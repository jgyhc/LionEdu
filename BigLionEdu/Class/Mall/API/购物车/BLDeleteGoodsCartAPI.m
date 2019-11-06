//
//  BLDeleteGoodsCartAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLDeleteGoodsCartAPI.h"

@implementation BLDeleteGoodsCartAPI

- (NSString *)methodName {
    return @"appShoppingMall/deleteGoodsCart";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeDelete;
}

@end
