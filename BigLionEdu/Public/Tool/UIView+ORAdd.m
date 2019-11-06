//
//  UIView+ORAdd.m
//  NTStartget
//
//  Created by 欧阳荣 on 2018/4/20.
//  Copyright © 2018年 NineTonTech. All rights reserved.
//

#import "UIView+ORAdd.h"
#import "NTCatergory.h"
#import "Aspects.h"

@implementation UIView (ORAdd) 



- (NSArray *)_or_getCGColors {
    if (self.gradientColors.count > 0) {
        return @[(__bridge id)self.gradientColors.firstObject.CGColor, (__bridge id)self.gradientColors.lastObject.CGColor];
    }
    return nil;
}

- (void)or_layoutLayers {
    self.gradientLayer.frame = self.bounds;
}

- (void)layoutSubviews {
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.cornerRadius = self.layer.cornerRadius;
}

- (void)setGradientColors:(NSArray<UIColor *> *)gradientColors {
    [self or_setGradientColors:gradientColors style:ORGradientStyleLeftToRight];
}

- (void)or_setGradientColors:(NSArray<UIColor *> *)gradientColors style:(ORGradientStyle)style {
    
    [self nt_setAssociateValue:gradientColors withKey:@selector(setGradientColors:)];
    
    if (!self.gradientLayer) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        
        gradientLayer.zPosition = -100;
        gradientLayer.cornerRadius = self.layer.cornerRadius;
        [self.layer addSublayer:gradientLayer];
        [self nt_setAssociateValue:gradientLayer withKey:@"gradientLayer"];
    }
    
    if (style == ORGradientStyleLeftToRight) {
        self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        //            gradientLayer.startPoint = CGPointMake(0, 0);
        //            gradientLayer.endPoint = CGPointMake(1.0, 0);
        //            gradientLayer.locations = @[@(0.0f), @(1.0f)];
    }
    self.gradientLayer.colors = [self _or_getCGColors];
}

- (NSArray<UIColor *> *)gradientColors {
    return [self nt_getAssociatedValueForKey:@selector(setGradientColors:)];
}

- (CALayer *)gradientLayer {
    return [self nt_getAssociatedValueForKey:@"gradientLayer"];
}

- (void)or_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    [self _or_addRoundedCorners:corners withRadii:radii];
    
    NT_WEAKIFY(self);
    [self aspect_hookSelector:@selector(layoutSubviews) withOptions:AspectPositionAfter usingBlock:^{
        NT_STRONGIFY(self);
        [self _or_addRoundedCorners:corners withRadii:radii];
    } error:nil];
    
}

- (void)or_addRoundedCorners:(UIRectCorner)corners withRadiif:(CGFloat)radiif {
    
    [self _or_addRoundedCorners:corners withRadii:CGSizeMake(radiif, radiif)];
    NT_WEAKIFY(self);
    [self aspect_hookSelector:@selector(layoutSubviews) withOptions:AspectPositionAfter usingBlock:^{
        NT_STRONGIFY(self);
        [self _or_addRoundedCorners:corners withRadii:CGSizeMake(radiif, radiif)];
    } error:nil];
}
    
- (void)_or_addRoundedCorners:(UIRectCorner)corners
                    withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

- (void)setOr_cornerRadius:(CGFloat)or_cornerRadius {
    [self or_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(or_cornerRadius, or_cornerRadius)];
}

- (CGFloat)or_cornerRadius {
    return 0;
}

/**
 *  从图片中按指定的位置大小截取图片的一部分
 *
 *  @param image UIImage image 原始的图片
 *  @param rect  CGRect rect 要截取的区域
 *
 *  @return UIImage
 */
+ (UIImage *)th_imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}



@end
