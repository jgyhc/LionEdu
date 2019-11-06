//
//  BLQuestionYearViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/19.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^didSelectYearHanlder)(NSString *year);

@interface BLQuestionYearViewController : UIViewController

@property (nonatomic, copy) NSString * startYear;

@property (nonatomic, copy) NSString * endYear;

@property (nonatomic, copy) didSelectYearHanlder block;
@end

NS_ASSUME_NONNULL_END
