//
//  BLFillTopicKeyModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/24.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLFillTopicKeyModel : NSObject

@property (nonatomic, copy) NSString * type;

@property (nonatomic, copy, nonnull) NSString * value;

@property (nonatomic, strong, nonnull) UIImage *  image;

@end

NS_ASSUME_NONNULL_END
