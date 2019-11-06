//
//  BLQuestionScreeningViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/18.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DidSelectScreenHanlder)(NSDictionary *params);
@interface BLQuestionScreeningViewController : UIViewController
@property (nonatomic, copy) DidSelectScreenHanlder didSelectScreenHanlder;


@end

NS_ASSUME_NONNULL_END
