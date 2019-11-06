//
//  UIView+ORAdd.h
//  NTStartget
//
//  Created by 欧阳荣 on 2018/4/20.
//  Copyright © 2018年 NineTonTech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, ORGradientStyle) {
    ORGradientStyleLeftToRight,//左->右渐变
    ORGradientStyleTopToBottom//上->下渐变
};

@interface UIView (ORAdd)

@property (nonatomic, strong) NSArray <UIColor *> *gradientColors;

@property (nonatomic, strong, readonly) CAGradientLayer *gradientLayer;;

@property (nonatomic, assign) CGFloat or_cornerRadius;

    
- (void)or_layoutLayers;


- (void)or_setGradientColors:(NSArray <UIColor *> *)gradientColors style:(ORGradientStyle)style;

#pragma mark - 设置部分圆角

- (void)or_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
- (void)or_addRoundedCorners:(UIRectCorner)corners
                   withRadiif:(CGFloat)radiif;

#pragma mark -- other
+ (UIImage *)th_imageFromImage:(UIImage *)image inRect:(CGRect)rect;



    
@end
