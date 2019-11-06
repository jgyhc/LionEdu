//
//  NTCircleClockModel.h
//  NTStartget
//
//  Created by jiang on 2018/9/29.
//  Copyright © 2018年 NineTonTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NTCircleClockModel : NSObject

@property (nonatomic,strong)UIImage *contentImg;
@property (nonatomic,assign)NSInteger deleteType;
@property (nonatomic,assign)NSInteger voiceType;  //1 图片  2 视频

+ (instancetype)modelWithImg:(UIImage *)img;
+ (instancetype)imageModelWithImg:(UIImage *)img;
+ (instancetype)videoModelWithImg:(UIImage *)img;


@end
