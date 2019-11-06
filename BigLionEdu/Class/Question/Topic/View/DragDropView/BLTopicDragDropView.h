//
//  BLTopicDragDropView.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/11.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BLTopicDragDropViewDelegate <NSObject>

- (UIScrollView *)bottomScrollView;

- (void)updateBottomScrollViewWithY:(CGFloat)y;

- (UIView *)contentView;

- (UIView *)subView;

@end

@interface BLTopicDragDropView : UIView

@property (nonatomic, weak) id<BLTopicDragDropViewDelegate> delegate;




@end

NS_ASSUME_NONNULL_END
