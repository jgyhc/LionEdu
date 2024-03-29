//
//  BLZFTableHeaderView.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLZFTableHeaderView : UIView

@property (nonatomic, strong, readonly) UIImageView *coverImageView;

@property (nonatomic, copy) void(^playCallback)(void);

@end

NS_ASSUME_NONNULL_END
