//
//  ZLFactory.h
//  ZhenLearnDriving_Coach
//
//  Created by OrangesAL on 2019/3/31.
//  Copyright © 2019年 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLFactory : NSObject

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor;

+ (UITextField *)textFieldWithFont:(UIFont *)font textColor:(UIColor *)textColor leftSpace:(CGFloat)leftSpace;

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)textColor;
+ (UIButton *)buttonWithImageName:(NSString *)imageName;


@end

NS_ASSUME_NONNULL_END
