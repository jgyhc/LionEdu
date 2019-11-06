//
//  BLUpdateGoodsCartNmAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/11/3.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLUpdateGoodsCartNmAPI.h"

@implementation BLUpdateGoodsCartNmAPI

- (NSString *)methodName {
    return @"appShoppingMall/updateGoodsCartNm";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}


@end
