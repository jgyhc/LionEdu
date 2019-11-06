//
//  BLGetPopularRecommendAPI.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLGetPopularRecommendAPI.h"

@implementation BLGetPopularRecommendAPI


- (NSString *)methodName {
    return @"appItemBank/getPopularRecommend";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

@end
