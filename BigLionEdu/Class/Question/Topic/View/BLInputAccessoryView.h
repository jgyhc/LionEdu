//
//  BLInputAccessoryView.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BLInputAccessoryViewDelegate <NSObject>

- (void)photoSelectEvent;

- (void)cameraSelectEvent;

- (void)finishEvent;
@end

@interface BLInputAccessoryView : UIView

@property (nonatomic, weak) id<BLInputAccessoryViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
