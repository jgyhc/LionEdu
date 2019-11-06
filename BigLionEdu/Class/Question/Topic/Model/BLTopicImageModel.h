//
//  BLTopicImageModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTopicImageModel : NSObject
@property (nonatomic, copy) NSString * url;

@property (nonatomic, strong) UIImage * image;

@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
