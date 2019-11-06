//
//  BLTopicFontManager.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/16.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTopicFontManager : NSObject
+ (instancetype)sharedInstance;

//-1小  0适中  1大
@property (nonatomic, assign) NSInteger fontSizeType;


@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIFont *contentFont;


@property (nonatomic, assign) NSInteger currentTopicCount;

@end

NS_ASSUME_NONNULL_END
