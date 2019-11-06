//
//  ZLTextView.h
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IQTextView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLTextView : UIView

@property (nonatomic, strong) IQTextView *textView;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) NSString * text;

@property (nonatomic, assign) NSInteger maxWords;

@end

NS_ASSUME_NONNULL_END
