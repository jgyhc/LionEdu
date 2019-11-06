//
//  BLScreeningItemModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/18.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BLAreaModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLScreeningItemModel : NSObject
@property (nonatomic, copy) NSString * title;

@property (nonatomic, assign) BOOL select;

@property (nonatomic, assign) CGFloat textWidth;

@property (nonatomic, strong) BLAreaModel *model;
@end

NS_ASSUME_NONNULL_END
