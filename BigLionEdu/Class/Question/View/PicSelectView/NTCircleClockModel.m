//
//  NTCircleClockModel.m
//  NTStartget
//
//  Created by jiang on 2018/9/29.
//  Copyright © 2018年 NineTonTech. All rights reserved.
//

#import "NTCircleClockModel.h"

@implementation NTCircleClockModel

+ (instancetype)imageModelWithImg:(UIImage *)img {
    NTCircleClockModel *model = [NTCircleClockModel new];
    model.contentImg = img;
    model.deleteType = 1;
    model.voiceType = 1;
    return model;
}

+ (instancetype)videoModelWithImg:(UIImage *)img {
    NTCircleClockModel *model = [NTCircleClockModel new];
    model.contentImg = img;
    model.deleteType = 1;
    model.voiceType = 2;
    return model;
}

+ (instancetype)modelWithImg:(UIImage *)img {
    NTCircleClockModel *model = [NTCircleClockModel new];
    model.contentImg = img;
    return model;
}

@end
