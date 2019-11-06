//
//  BLGoodsCartPriceAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/6.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGoodsCartPriceAPI.h"

@implementation BLGoodsCartPriceAPI

- (NSString *)methodName {
    return @"appShoppingMall/GoodsCartPrice";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}


@end
